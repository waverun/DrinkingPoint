import FirebaseCore
import FirebaseAuth
import GoogleSignIn

func signInWithGoogle(completion: @escaping (String?) -> ()) {
    guard let clientID = FirebaseApp.app()?.options.clientID,
    let topViewConroller = UIViewController.getTopViewController() else { return }

    // Create Google Sign In configuration object.
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config

    // Start the sign in flow!
    GIDSignIn.sharedInstance.signIn(withPresenting: topViewConroller) { result, error in
        guard error == nil else {
            print("sign in with google error:", error!.localizedDescription)
            return
        }

        guard let user = result?.user,
              let idToken = user.idToken?.tokenString
        else {
            print("sign in with google error: result or user are nil")
            return
        }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: user.accessToken.tokenString)

        Auth.auth().signIn(with: credential) { result, error in
            completion(error?.localizedDescription)}
    }
}
