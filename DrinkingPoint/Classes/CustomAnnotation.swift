import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var imageURL: String?
    var image: UIImage?
    var documentID: String
    var userUID: String

    init(coordinate: CLLocationCoordinate2D, title: String, imageURL: String, documentID: String, userUID: String) {
        self.coordinate = coordinate
        self.title = title
        self.imageURL = imageURL
        self.documentID = documentID
        self.userUID = userUID
    }
}
