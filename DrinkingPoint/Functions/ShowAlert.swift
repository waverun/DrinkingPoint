//import UIKit
//
//func showAlert(title: String, message: String) {
//
//    guard let topViewController = UIViewController.getTopViewController() else {
//        print("Top view controller not found")
//        return
//    }
//
//    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//    alert.addAction(okAction)
//
//    topViewController.present(alert, animated: true, completion: nil)
//}

import UIKit

func showAlert(title: String, message: String, documentID: String, uniqueFileName: String) {

    guard let topViewController = UIViewController.getTopViewController() else {
        print("Top view controller not found")
        return
    }

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    // Add a text field to the alert
    alert.addTextField { textField in
        // Configure the text field (optional)
        textField.placeholder = "Enter something"
        // Other configurations like setting the keyboard type, text alignment, etc.
    }

    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
        // Handle the text from the text field if needed
        if let textField = alert.textFields?.first, let text = textField.text?.trimmingCharacters(in:  CharacterSet(charactersIn: " ")) {
            //            var title = text
            //            if text.isEmpty {
            //                title = "Water"
            //            }
            print("Text field text: \(text)")
            if text.isEmpty {
                showRemoveDocumentAlert(documentID: documentID, uniqueFileName: uniqueFileName)
            } else {
                updateDocument(data: ["title" : text], documentID: documentID)
            }
        }
    }

    alert.addAction(okAction)

    topViewController.present(alert, animated: true, completion: nil)
}
