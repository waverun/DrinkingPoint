import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
//    @ObservedObject var locationManager = LocationManager()
//    @StateObject private var imagePickerViewModel = ImagePickerViewModel()

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.showsUserLocation = true
        addSnapshotListener()
        return mapView
    }

        func updateUIView(_ uiView: MKMapView, context: Context) {
            if let userLocation = LocationManager.shared.location {
                let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
                uiView.setRegion(region, animated: true)
            }
        }
}
