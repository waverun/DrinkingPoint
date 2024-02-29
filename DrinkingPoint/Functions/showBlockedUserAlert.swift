import UIKit

/// Shows an alert asking the user to confirm the upload by agreeing to the terms.
/// - Parameters:
///   - completion: A closure that is called when the user agrees to the terms and confirms the upload.
func showBlockedUserAlert() {
    guard let topViewController = UIViewController.getTopViewController() else {
        print("Top view controller not found")
        return
    }

    let alert = UIAlertController(title: "User is blocked", message: "You can't upload until the user is reviewed.", preferredStyle: .alert)

    // Add a Cancel action
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    // Add actions to the alert
    alert.addAction(cancelAction)

    // Present the alert
    topViewController.present(alert, animated: true, completion: nil)
}
