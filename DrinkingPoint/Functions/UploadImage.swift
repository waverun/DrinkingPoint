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
    //    let imageRef = storageRef.child("images/rivers.jpg")
    
    let uniqueFileName = "images/\(UUID().uuidString).jpg"

    // Create a reference to the file you want to upload
    let imageRef = storageRef.child(uniqueFileName)


    // Upload the file to the path "images/rivers.jpg"
    _ = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
        guard metadata != nil else {
            print("Uh-oh, an error occurred! \(error?.localizedDescription ?? "unknown error")")
            return
        }
        // Metadata contains file metadata such as size, content-type.
//        let size = metadata.size
        // You can also access to download URL after upload.
        imageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
                print("Uh-oh, an error occurred! \(error?.localizedDescription ?? "unknown error")")
                return
            }
            print("image updloaded succesfully. url: \(downloadURL)")

            if let userLocation = LocationManager.shared.location {
                addDocument(data: [
                    "latitude" : userLocation.latitude,
                    "longitude" : userLocation.longitude,
                    "URL" : downloadURL.absoluteString]) { documentRef in 
                        DispatchQueue.main.async {
                            showAlert(title: "Uploaded", message: "Drinking point was added succesfully")
                        }
                    }
            }

        }
    }
}
