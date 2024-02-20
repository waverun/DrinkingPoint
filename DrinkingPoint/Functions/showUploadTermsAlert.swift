import UIKit

/// Shows an alert asking the user to confirm the upload by agreeing to the terms.
/// - Parameters:
///   - completion: A closure that is called when the user agrees to the terms and confirms the upload.
func showUploadTermsAlert(completion: @escaping () -> Void) {
    guard let topViewController = UIViewController.getTopViewController() else {
        print("Top view controller not found")
        return
    }

    let alert = UIAlertController(title: "Confirm Upload", message: "By uploading, you agree to our terms. Ensure your content does not violate our policies against objectionable content or abusive behavior.", preferredStyle: .alert)

    // Add an Agree action that calls the completion handler
    let agreeAction = UIAlertAction(title: "Agree", style: .default) { _ in
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
