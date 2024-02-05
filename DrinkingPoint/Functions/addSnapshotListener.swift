import MapKit

var pointsAdded : [pointAdded] = []

struct pointAdded {
    var documentID: String
    var latitude, longitude : Double
    var title: String
    var imageURL: String
}

func removePointByDocumentID(_ documentID: String) {
    pointsAdded.removeAll { $0.documentID == documentID }
}

func addSnapshotListener() {
    FirestoreManager.shared.db.collection("drinkingPoints") //.whereField("state", isEqualTo: "CA")
        .addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                func addPoint() {
                    let data = diff.document.data()
                    if let latitude = data["latitude"] as? Double, let longitude = data["longitude"] as? Double,
                       let title = data["title"] as? String,
                       let imageURL = data["URL"] as? String {
                        let documentID = diff.document.documentID // Access the documentID here
                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        MapViewManager.shared.addAnnotation(at: coordinate, withTitle: title, imageURL: imageURL)

                        if let point = findPointByLocation(latitude: latitude, longitude: longitude, withinMeters: 20) {
                            removeDocument(documentID: point.documentID)
                        }
                        pointsAdded.append(pointAdded(documentID: documentID, latitude: latitude, longitude: longitude, title: title, imageURL: imageURL))
                    }
                }
                switch diff.type {
                    case .added:
                    print("New city: \(diff.document.data())")
                        addPoint()
                    case .modified:
                    print("Modified city: \(diff.document.data())")
                        addPoint()
                    case .removed:
                    print("Removed city: \(diff.document.data())")
                    let documentID = diff.document.documentID // Access the documentID here
                    removePointByDocumentID(documentID)
                }
            }
        }

}
