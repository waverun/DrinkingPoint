import CoreLocation
import UIKit

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

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else { return }
//        self.location = location.coordinate
//        if needToUpdateRegion {
//            MapViewManager.shared.updateRegion(userLocation: self.location!)
//        }
//    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Iterate through all available locations
        for location in locations.reversed() {
            let coordinate = location.coordinate

            // Update the current location with the coordinate
            self.location = coordinate

            if self.location == nil {
                continue
            }

            // Check if there's a need to update the region and do so if necessary
            if needToUpdateRegion {
                MapViewManager.shared.updateRegion(userLocation: coordinate)
                // Assuming you only want to update the region once based on the first valid location
                break
            }
        }
    }

    func checkLocationAuthorization() {
        let status = locationManager.authorizationStatus // For iOS 14 and later
        switch true {
            case status == .notDetermined:
                // Location permission has not been asked yet, request it.
                locationManager.requestWhenInUseAuthorization()
            case status == .restricted, status == .denied:
                // Location permission was denied or restricted, guide the user.
                promptForLocationSettings()
            case status == .authorizedAlways, status == .authorizedWhenInUse:
                // Permission granted, proceed with location-dependent operation.
                break
            default:
                // Handle unexpected cases.
                break
        }
    }

    private func promptForLocationSettings() {
        guard let topViewController = UIViewController.getTopViewController() else {
            print("Top view controller not found")
            return
        }
        let alertController = UIAlertController(
            title: "Location Services Required",
            message: "This feature requires access to your location. Please enable location services in your settings.",
            preferredStyle: .alert
        )

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    // Finished opening URL, may check for success if needed
                })
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)

        DispatchQueue.main.async {
            // Present the alert from the current view controller
        topViewController.present(alertController, animated: true, completion: nil)
        }
    }
}
