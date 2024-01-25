import Firebase
import FirebaseStorage
//import UIKit

func uploadImage(imageData: Data) {
    // Data in memory
//    let data = Data()
    let storage = Storage.storage()

    // Create a root reference
    let storageRef = storage.reference()

    // Create a reference to the file you want to upload
    let riversRef = storageRef.child("images/rivers.jpg")

    // Upload the file to the path "images/rivers.jpg"
    _ = riversRef.putData(imageData, metadata: nil) { (metadata, error) in
        guard let metadata = metadata else {
            print("Uh-oh, an error occurred! \(error?.localizedDescription ?? "unknown error")")
            return
        }
        // Metadata contains file metadata such as size, content-type.
//        let size = metadata.size
        // You can also access to download URL after upload.
        riversRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
                print("Uh-oh, an error occurred! \(error?.localizedDescription ?? "unknown error")")
                return
            }
            print("image updloaded succesfully. url: \(downloadURL)")
        }
    }
}
