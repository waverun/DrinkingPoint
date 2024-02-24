import FirebaseAuth
import Combine

class UserAuthManager: ObservableObject {
    @Published var lastSignedInEmail: String? = UserDefaults.standard.string(forKey: "lastSignedInEmail")

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
}
