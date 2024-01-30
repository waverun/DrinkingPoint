import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    static let shared = LocationManager()

    private let locationManager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    var needToUpdateRegion = true

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location.coordinate
        if needToUpdateRegion {
            MapViewManager.shared.updateRegion(userLocation: self.location!)
        }
    }
}
