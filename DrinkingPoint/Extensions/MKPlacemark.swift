import MapKit

extension MKPlacemark {
    var radius: Double {
        get { return (self.region as! CLCircularRegion).radius }
    }
}

