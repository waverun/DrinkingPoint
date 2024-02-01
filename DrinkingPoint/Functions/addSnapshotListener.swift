import MapKit

func addSnapshotListener() {
    FirestoreManager.shared.db.collection("drinkingPoints") //.whereField("state", isEqualTo: "CA")
        .addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    print("New city: \(diff.document.data())")
                    let data = diff.document.data()
                    if let latitude = data["latitude"] as? Double, let longitude = data["longitude"] as? Double, let title = data["title"] as? String {
                        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        MapViewManager.shared.addAnnotation(at: coordinate, withTitle: title)
                    }                }
                if (diff.type == .modified) {
                    print("Modified city: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("Removed city: \(diff.document.data())")
                }
            }
        }
}
