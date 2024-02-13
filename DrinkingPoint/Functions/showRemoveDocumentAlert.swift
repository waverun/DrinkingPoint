import UIKit

func showRemoveDocumentAlert(documentID: String, uniqueFileName: String) {
    guard let topViewController = UIViewController.getTopViewController() else {
        print("Top view controller not found")
        return
    }

    let alert = UIAlertController(title: "Remove Point", message: "Type 'remove' to confirm.", preferredStyle: .alert)

    // Add a text field to the alert
    alert.addTextField { textField in
        textField.placeholder = "Type 'remove' here"
    }

    // Create the Remove action but leave it disabled initially
    let removeAction = UIAlertAction(title: "Remove", style: .destructive) { _ in
        // Call the function to remove the document
        removeDocument(documentID: documentID, uniqueFileName: uniqueFileName)
    }
    removeAction.isEnabled = false

    // Add a Cancel action
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        updateDocument(data: ["title" : ""], documentID: documentID)
    }

    // Add actions to the alert
    alert.addAction(cancelAction)
    alert.addAction(removeAction)

    // Monitor the text field for changes
    NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: alert.textFields?.first, queue: OperationQueue.main) { notification in
        if let textField = alert.textFields?.first, let text = textField.text {
            // Enable the Remove action only if the user types "remove"
            removeAction.isEnabled = text.lowercased() == "remove"
        }
    }

    // Present the alert
    topViewController.present(alert, animated: true, completion: nil)
}
