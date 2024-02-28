import UIKit

/// Shows an alert asking the user to confirm the upload by agreeing to the terms.
/// - Parameters:
///   - completion: A closure that is called when the user agrees to the terms and confirms the upload.
func showReportUserAlert(completion: @escaping () -> Void) {
    guard let topViewController = UIViewController.getTopViewController() else {
        print("Top view controller not found")
        return
    }

    let alert = UIAlertController(title: "All points of that user will be reported", message: "Are you shure you want to report the user? Note that all future uploads of that user will be blocked!", preferredStyle: .alert)

    // Add an Agree action that calls the completion handler
    let agreeAction = UIAlertAction(title: "Report user", style: .default) { _ in
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
