import MapKit
import GeohashKit
import FirebaseFirestore

var pointsAdded : [PointAdded] = []

struct PointAdded {
    var documentID: String
    var latitude, longitude : Double
    var title: String
    var imageURL: String
    var uniqueFileName: String
}

func removePointByDocumentID(_ documentID: String) {
    // First, filter the points to find those that should be removed
    let removedPoints = pointsAdded.filter { $0.documentID == documentID }

    for point in removedPoints {
        MapViewManager.shared.removeAllAnnotations(byImageUrl: point.imageURL)
    }

    pointsAdded.removeAll { $0.documentID == documentID }
}

var listenerRegistration: (any ListenerRegistration)?

func getGeohash(latitude: Double, longitude: Double, precision: Int = 7) -> String? {
    let location = Geohash.Coordinates(latitude: latitude, longitude: longitude)
    let geohash = Geohash(coordinates: location, precision: precision)
    return geohash?.geohash
}

func addSnapshotListener(forRegion: MKCoordinateRegion) {
    FirestoreManager.shared.db.collection("drinkingPoints")
    listenerRegistration?.remove()

    // Calculate new geohash range
    if let lowerBoundGeohash = getGeohash(latitude: forRegion.center.latitude - forRegion.span.latitudeDelta / 2, longitude: forRegion.center.longitude - forRegion.span.longitudeDelta / 2),
       let upperBoundGeohash = getGeohash(latitude: forRegion.center.latitude + forRegion.span.latitudeDelta / 2, longitude: forRegion.center.longitude + forRegion.span.longitudeDelta / 2) {
        
        // Set up a new snapshot listener
        listenerRegistration = FirestoreManager.shared.db.collection("drinkingPoints")
            .whereField("geohash", isGreaterThanOrEqualTo: lowerBoundGeohash)
            .whereField("geohash", isLessThanOrEqualTo: upperBoundGeohash)
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                //        .addSnapshotListener { querySnapshot, error in
                //            guard let snapshot = querySnapshot else {
                //                print("Error fetching snapshots: \(error!)")
                //                return
                //            }
                snapshot.documentChanges.forEach { diff in
                    func addPoint() {
                        let data = diff.document.data()
                        if let latitude = data["latitude"] as? Double, let longitude = data["longitude"] as? Double,
                           let title = data["title"] as? String,
                           let imageURL = data["URL"] as? String,
                           let uniqueFileName = data["uniqueFileName"] as? String {
                            let documentID = diff.document.documentID // Access the documentID here
                            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

//                            let points = findPointsByLocation(latitude: latitude, longitude: longitude, withinMeters: 20)
//                            for point in points {
//                                removeDocument(documentID: point.documentID)
//                            }
                            removePointByDocumentID(documentID)

                            let reportReason = data["reportReason"] as? String ?? ""
                            #if !DEBUG
                            guard reportReason.isEmpty else {
                                print("Point " + title + " ignored due to reportReason: " + reportReason)
                                return
                            }
                            #endif
                            pointsAdded.append(PointAdded(documentID: documentID, latitude: latitude, longitude: longitude, title: title, imageURL: imageURL, uniqueFileName: uniqueFileName))

                            MapViewManager.shared.addAnnotation(at: coordinate, withTitle: title, imageURL: imageURL, documentID: documentID)
                        }
                    }
                    switch diff.type {
                        case .added:
                            print("New city: \(diff.document.data())")
                            addPoint()
                        case .modified:
                            print("Modified city: \(diff.document.data())")
//                            let data = diff.document.data()
                            addPoint()
//                            if let title = data["title"] as? String,
//                               title.isEmpty {
//                                let documentID = diff.document.documentID
//                                showRemoveDocumentAlert(documentID: documentID)
//                            }
                        case .removed:
                            print("Removed city: \(diff.document.data())")
                            let documentID = diff.document.documentID // Access the documentID here
                            
//                            let data = diff.document.data()
                            removePointByDocumentID(documentID)
//                            if let uniqueFileName = data["uniqueFileName"] as? String {
//                                deleteImage(imageRef: uniqueFileName)
//                            }
                            //                    if let imageName = data[""]
                    }
                }
            }
    }
}
