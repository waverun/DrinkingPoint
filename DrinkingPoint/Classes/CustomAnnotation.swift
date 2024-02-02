import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
//    var subtitle: String?
    var imageURL: String?

    init(coordinate: CLLocationCoordinate2D, title: String, imageURL: String) {
        self.coordinate = coordinate
        self.title = title
//        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}
