import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @ObservedObject var locationManager = LocationManager()

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.showsUserLocation = true
        return mapView
    }

        func updateUIView(_ uiView: MKMapView, context: Context) {
            if let userLocation = locationManager.location {
                let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
                uiView.setRegion(region, animated: true)
            }
        }
}
