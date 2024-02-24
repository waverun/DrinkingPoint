import SwiftUI
struct LoginView: View {
    @ObservedObject var authManager = UserAuthManager()
    @State private var email: String = UserDefaults.standard.string(forKey: "lastSignedInEmail") ?? ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if showPassword {
                TextField("Password", text: $password)
            } else {
                SecureField("Password", text: $password)
            }

            Button(action: { self.showPassword.toggle() }) {
                Text(showPassword ? "Hide Password" : "Show Password")
            }

            Button("Login") {
                authManager.signIn(email: email, password: password) { success, message in
                    if success {
                        // Navigate to the next screen or update the UI accordingly
                    } else {
                        self.errorMessage = message
                    }
                }
            }

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button("Forgot Password?") {
                authManager.resetPassword(email: email) { success, message in
                    if success {
                        // Show success message to the user
                    } else {
                        self.errorMessage = message
                    }
                }
            }
        }
        .padding()
    }
}
