import UIKit

func showAlert(title: String, message: String) {

    guard let topViewController = UIViewController.getTopViewController() else {
        print("Top view controller not found")
        return
    }

    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(okAction)

    topViewController.present(alert, animated: true, completion: nil)
}
