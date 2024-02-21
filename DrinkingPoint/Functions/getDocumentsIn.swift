import FirebaseFirestore

func getDocumentsIn(fieldName: String, values: [String], onSuccess: @escaping ([PointAdded]) -> Void) {
    FirestoreManager.shared.db.collection("drinkingPoints").whereField(fieldName, in: values).getDocuments { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            var reportedPoints: [PointAdded] = []
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
                let data = document.data()
                if let latitude = data["latitude"] as? Double,
                   let longitude = data["longitude"] as? Double,
                   let title = data["title"] as? String,
                   let imageURL = data["imageURL"] as? String,
                   let uniqueFileName = data["uniqueFileName"] as? String {
                    let reportedPoint = PointAdded(documentID: document.documentID, latitude: latitude, longitude: longitude, title: title, imageURL: imageURL, uniqueFileName: uniqueFileName)
                    reportedPoints.append(reportedPoint)
                }
            }
            onSuccess(pointsAdded)
        }
    }
}
