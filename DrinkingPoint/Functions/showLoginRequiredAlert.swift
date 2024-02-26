import UIKit

/// Shows an alert asking the user to confirm the upload by agreeing to the terms.
/// - Parameters:
///   - completion: A closure that is called when the user agrees to the terms and confirms the upload.
func showLoginRequiredAlert(inOrder: String, completion: @escaping () -> Void) {
    guard let topViewController = UIViewController.getTopViewController() else {
        print("Top view controller not found")
        return
    }

    let alert = UIAlertController(title: "User not signed in", message: "You have to sign in order to " + inOrder, preferredStyle: .alert)

    // Add an Agree action that calls the completion handler
    let agreeAction = UIAlertAction(title: "Sign In", style: .default) { _ in
        completion()
    }

    // Add a Cancel action
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    // Add actions to the alert
    alert.addAction(cancelAction)
    alert.addAction(agreeAction)

    // Present the alert
    topViewController.present(alert, animated: true, completion: nil)
}
