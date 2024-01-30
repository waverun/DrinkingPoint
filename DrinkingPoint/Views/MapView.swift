import SwiftUI
import MapKit

//struct MapView: UIViewRepresentable {
//
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView(frame: .zero)
//        mapView.showsUserLocation = true
//        addSnapshotListener()
//        return mapView
//    }
//
//        func updateUIView(_ uiView: MKMapView, context: Context) {
//            if let userLocation = LocationManager.shared.location {
//                let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
//                uiView.setRegion(region, animated: true)
//            }
//        }
//}

class MapViewManager {
    static let shared = MapViewManager()
    private init() {}

    let mapView = MKMapView(frame: .zero)

    func makeMapView() -> MKMapView {
        mapView.showsUserLocation = true
        // Add any additional setup here
        return mapView
    }

    func updateMapView(_ mapView: MKMapView, with userLocation: CLLocationCoordinate2D?) {
        if let userLocation = userLocation {
            updateRegion(userLocation: userLocation)
        }
    }

    func updateRegion(userLocation: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)

    }
}

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        return MapViewManager.shared.makeMapView()
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let userLocation = LocationManager.shared.location
        MapViewManager.shared.updateMapView(uiView, with: userLocation)
    }
}
