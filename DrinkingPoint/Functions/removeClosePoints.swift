
import MapKit

func removeClosePoints(location: CLLocationCoordinate2D, uniqueFileName: String, dispatchGroup: DispatchGroup? = nil) {
    let points = findPointsByLocation(latitude: location.latitude, longitude: location.longitude, withinMeters: 20)
    for point in points {
        if point.uniqueFileName != uniqueFileName {
            dispatchGroup?.enter()
            removeDocument(documentID: point.documentID, uniqueFileName: point.uniqueFileName) {
                dispatchGroup?.leave()
            }
        }
    }
}
