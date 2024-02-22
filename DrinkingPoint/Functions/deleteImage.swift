//import Firebase
import FirebaseStorage
//import UIKit

func deleteImage(imageRef: String, completion: (() -> Void)?) {
    // Create a reference to the file to delete
    let storage = Storage.storage()
    let storageRef = storage.reference()

    let desertRef = storageRef.child(imageRef)

    // Delete the file
    desertRef.delete { error in
        if let error = error {
            // There was an error deleting the file
            print("Error deleting file: \(error.localizedDescription)")
            if let completion = completion {
                completion()
            }
        } else {
            // File deleted successfully
            print("File deleted successfully")
            if let completion = completion {
                completion()
            }
        }
    }
}
