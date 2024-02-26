import SwiftUI
struct LoginView: View {
//    @ObservedObject var authManager = UserAuthManager()
    @EnvironmentObject var authManager: UserAuthManager
    @Environment(\.presentationMode) var presentationMode

    @State private var email: String = UserDefaults.standard.string(forKey: "lastSignedInEmail") ?? ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var errorMessage: String?
    @State private var successMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20) // Adds space below the title
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                    if showPassword {
                        TextField("Password", text: $password)
                    } else {
                        SecureField("Password", text: $password)
                    }

                HStack() {
                    Button(action: { self.showPassword.toggle() }) {
                        Text(showPassword ? "Hide Password" : "Show Password")
                    }

                    Spacer()

                    Button("Forgot Password?") {
                        authManager.resetPassword(email: email) { success, message in
                            if success {
                                self.errorMessage = nil // Clear any existing error messages
                                self.successMessage = "A password reset email has been sent."
                            } else {
                                self.successMessage = nil // Clear any existing success messages
                                self.errorMessage = message
                            }
                        }
                    }
                }
                
                Spacer()

                Button("Login") {
                    authManager.signIn(email: email, password: password) { success, message in
                        if success {
                            self.presentationMode.wrappedValue.dismiss()
                        } else {
                            self.errorMessage = message
                        }
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(40)
                .padding(.horizontal, 50)

                if let successMessage = successMessage {
                    Text(successMessage)
                        .foregroundColor(.green)
                        .padding()
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Spacer()
            }
            .padding()
            .navigationBarItems(trailing: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
