import Firebase
import FirebaseStorage
import CoreLocation
import GeohashKit

func uploadImage(userUID: String, imageData: Data) {
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
//                let userLocation = calculateDestinationPoint(from: userLocation, distanceMeters: 1000, bearingDegrees: 90)
//                MapViewManager.shared.updateRegion(userLocation: CLLocationCoordinate2D(latitude: 40.71279939264776, longitude: -73.99413542108108))
                let location = Geohash.Coordinates(latitude: userLocation.latitude, longitude: userLocation.longitude)
                if let geohash = Geohash(coordinates: location, precision: 7) {
                    addDocument(userUID: userUID, data: [
                        "latitude" : userLocation.latitude,
                        "longitude" : userLocation.longitude,
                        "geohash" : geohash.geohash,
                        "URL" : downloadURL.absoluteString,
                        "uniqueFileName" : uniqueFileName]) { documentID in
                            DispatchQueue.main.async {
                                showAlert(title: "Uploaded", message: "Drinking point was added succesfully", documentID: documentID, uniqueFileName: uniqueFileName)
                                removeClosePoints(location: userLocation, uniqueFileName: uniqueFileName)
//                                let points = findPointsByLocation(latitude: userLocation.latitude, longitude: userLocation.longitude, withinMeters: 20)
//                                for point in points {
//                                    if point.uniqueFileName != uniqueFileName {
//                                        removeDocument(documentID: point.documentID, uniqueFileName: point.uniqueFileName)
//                                    }
//                                }
                            }
                        }
                } else {
                    LocationManager.shared.checkLocationAuthorization()
                }
            }
        }
    }
}
