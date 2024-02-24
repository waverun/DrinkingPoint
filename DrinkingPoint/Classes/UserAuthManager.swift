import FirebaseAuth
import Combine

class UserAuthManager: ObservableObject {
    @Published var lastSignedInEmail: String? = UserDefaults.standard.string(forKey: "lastSignedInEmail")
    @Published var isUserAuthenticated: Bool = false
    @Published var currentUserEmail: String? = nil
    @Published var currentUserUID: String? = nil

    var handle: AuthStateDidChangeListenerHandle?

    init() {
        // Add the listener and update the authentication state based on whether a user is signed in or not
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.isUserAuthenticated = user != nil
            self?.currentUserEmail = user?.email
            self?.currentUserUID = user?.uid
        }
    }

    deinit {
        // Don't forget to remove the listener when this object is deallocated
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
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
}
