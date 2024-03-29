import FirebaseAuth
import SwiftUI
import FirebaseAuth
import AuthenticationServices
import CryptoKit
import FirebaseFirestore

class UserAuthManager: NSObject, ObservableObject {
    var firestoreListener: ListenerRegistration?

    @Published var lastSignedInEmail: String? = UserDefaults.standard.string(forKey: "lastSignedInEmail")
    @Published var isUserAuthenticated: Bool = false
    @Published var currentUserEmail: String? = nil
    @Published var currentUserUID: String? = nil
    @Published var currentUserName: String? = nil
    @Published var isCurrentUserBlocked: Bool = false

    var handle: AuthStateDidChangeListenerHandle?

    override init() {
        // Add the listener and update the authentication state based on whether a user is signed in or not
        super.init()
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.isUserAuthenticated = user != nil
            self?.currentUserEmail = user?.email
            self?.currentUserUID = user?.uid
            self?.currentUserName = user?.displayName
            self?.listenToUserChanges()
        }
    }

    deinit {
        // Don't forget to remove the listener when this object is deallocated
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        firestoreListener?.remove()
    }

    func signUp(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
                print("UserAuthManager: signUp error:", error)
            } else {
                UserDefaults.standard.set(email, forKey: "lastSignedInEmail")
                completion(true, nil)
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                UserDefaults.standard.set(email, forKey: "lastSignedInEmail")
                self?.lastSignedInEmail = email
                completion(true, nil)
            }
        }
    }

    func resetPassword(email: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isUserAuthenticated = false
            currentUserEmail = nil
            currentUserUID = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            // Handle the error if needed
        }
    }

    // MARK: - Apple sign in:

    private var currentNonce: String?

    // Initiate Sign in with Apple process
    func signInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    /// Hashes the `nonce` using SHA256.
    private func sha256(_ nonce: String) -> String {
        let inputData = Data(nonce.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()

        return hashString
    }
}

// Extend UserAuthManager to conform to ASAuthorizationControllerDelegate and ASAuthorizationControllerPresentationContextProviding
extension UserAuthManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential, let nonce = currentNonce, let appleIDToken = appleIDCredential.identityToken, let idTokenString = String(data: appleIDToken, encoding: .utf8) {
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                // Update user authentication status
                self.isUserAuthenticated = true
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Here, return the key window's anchor
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            fatalError("Unable to find a key window.")
        }
        return window
    }

    func listenToUserChanges() {
        guard let userId = currentUserUID else {
            print("User ID is not set")
            return
        }

        let db = Firestore.firestore()
        let userDocument = db.collection("users").document(userId)

        firestoreListener?.remove()

        firestoreListener = userDocument.addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error listening for user changes: \(error.localizedDescription)")
                return
            }

            guard let documentSnapshot = documentSnapshot else {
                print("Users snapshot couldn't be created.")
                return
            }

            guard documentSnapshot.exists, let data = documentSnapshot.data(), let isBlocked = data["isBlocked"] as? Bool else {
                // If the document does not exist, or it doesn't contain the 'isBlocked' field, treat as unblocked
                print("User document deleted or does not exist, or 'isBlocked' field is missing. Treating as unblocked.")
                isCurrentUserBlocked = false
                return
            }

            // If the code reaches here, it means the document exists, contains the 'isBlocked' field, and you can check the blocked status
            print("Is user blocked? \(isBlocked)")
            isCurrentUserBlocked = isBlocked
        }
    }
}
