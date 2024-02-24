import SwiftUI

struct SignUpView: View {
//    @ObservedObject var authManager = UserAuthManager()
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @EnvironmentObject var authManager: UserAuthManager

    @State private var email = ""
    @State private var password = ""
    @State private var passwordVerification = ""
    @State private var showPassword = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 20) // Adds space below the title

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom, 10) // Adds space below the email field

                Group {
                    if showPassword {
                        TextField("Password", text: $password)
                        TextField("Verify Password", text: $passwordVerification)
                    } else {
                        SecureField("Password", text: $password)
                        SecureField("Verify Password", text: $passwordVerification)
                    }
                }
                .padding(.bottom, 10) // Adds space below the password fields

                HStack {
                    Button(action: { self.showPassword.toggle() }) {
                        Text(showPassword ? "Hide Passwords" : "Show Passwords")
                    }
                    Spacer() // Aligns the button to the left
                }

                Button(action: signUp) {
                    Text("Sign Up")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(40)
                        .padding(.horizontal, 50)
                }
                .padding(.top, 10) // Adds space above the sign up button

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer() // Adds additional space at the bottom
            }
            .padding()
            .navigationBarItems(trailing: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }

    func signUp() {
        guard password == passwordVerification else {
            errorMessage = "Passwords do not match"
            return
        }

        authManager.signUp(email: email, password: password) { success, error in
            if success {
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                    // Assuming auto-login after signup, so you might not need to explicitly show LoginView
                    // If you need to show LoginView for any reason, consider a shared state or notification
                }
            } else {
                errorMessage = error
            }
        }
    }
}
