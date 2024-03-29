import FirebaseFirestore

func getDocumentsIn(fieldName: String, values: [String], completion: @escaping (Bool, [PointAdded]) -> Void) {
    FirestoreManager.shared.db.collection("drinkingPoints").whereField(fieldName, in: values).getDocuments { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
            completion(false, [])
        } else {
            var foundPoints: [PointAdded] = []
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
                let data = document.data()
                if let latitude = data["latitude"] as? Double,
                   let longitude = data["longitude"] as? Double,
                   let title = data["title"] as? String,
                   let imageURL = data["URL"] as? String,
                   let uniqueFileName = data["uniqueFileName"] as? String {
                    let reportReason = data["reportReason"] as? String ?? ""
                    let foundPoint = PointAdded(documentID: document.documentID, latitude: latitude, longitude: longitude, title: title, imageURL: imageURL, uniqueFileName: uniqueFileName, reportReason: reportReason)
                    foundPoints.append(foundPoint)
                }
            }
            completion(true, foundPoints)
        }
    }
}
