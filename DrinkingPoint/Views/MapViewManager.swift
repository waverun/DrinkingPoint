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

class MapViewManager: NSObject, MKMapViewDelegate {
    static let shared = MapViewManager()

    private override init() {}

    //    let mapView = MKMapView(frame: .zero)

    lazy var mapView: MKMapView = {
        let map = MKMapView(frame: .zero)
        map.delegate = self // Set delegate to self
        map.showsUserLocation = true
        // Other setup...
        return map
    }()

    func makeMapView() -> MKMapView {
        mapView.showsUserLocation = true
        // Add any additional setup here
        addSnapshotListener()
        return mapView
    }

    func updateMapView(_ mapView: MKMapView, with userLocation: CLLocationCoordinate2D?) {
        if let userLocation = userLocation {
            updateRegion(userLocation: userLocation)
        }
    }

    func updateRegion(userLocation: CLLocationCoordinate2D) {
        //        let userLocation = CLLocationCoordinate2D(latitude: 40.71, longitude: -74.0)
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }


    //    func addAnnotation(at coordinate: CLLocationCoordinate2D, withTitle title: String) {
    //        let annotation = MKPointAnnotation()
    //        annotation.coordinate = coordinate
    //        annotation.title = title
    //        mapView.addAnnotation(annotation)
    //    }

    func addAnnotation(at coordinate: CLLocationCoordinate2D, withTitle title: String, imageURL: String) {
        let annotation = CustomAnnotation(coordinate: coordinate, title: title, imageURL: imageURL)
        mapView.addAnnotation(annotation)
    }

    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //        // Check if the annotation is not the user's location
    //        if annotation is MKUserLocation {
    //            return nil
    //        }
    //
    //        let identifier = "Annotation"
    //        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    //
    //        if annotationView == nil {
    //            // Create a new annotation view
    //            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    //            annotationView?.canShowCallout = true // If you want to show a callout bubble
    //
    //            // Set the image for the annotation view using a system image
    //            let waterSymbol = UIImage(systemName: "drop.fill")
    //
    //            // Specify the light blue color you want to use
    //            let lightBlueColor = UIColor.systemBlue.withAlphaComponent(0.5) // Adjust alpha for lighter shade
    //
    //            // Apply the tint color to the image
    //            let lightBlueWaterSymbol = waterSymbol?.withTintColor(lightBlueColor, renderingMode: .alwaysTemplate)
    //
    //            let image = lightBlueWaterSymbol // ?.withTintColor(lightBlueColor)
    //
    //            annotationView?.image = image
    //
    //        } else {
    //            // Reuse the annotation view
    //            annotationView?.annotation = annotation
    //        }
    //
    //        return annotationView
    //    }

    //        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //            // Check if the annotation is not the user's location
    //            if annotation is MKUserLocation {
    //                return nil
    //            }
    //
    //            let identifier = "Annotation"
    //            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    //
    //            if annotationView == nil {
    //                // Create a new annotation view
    //                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    //                annotationView?.canShowCallout = true // If you want to show a callout bubble
    //
    //                // Create an UIImageView for the annotation view
    //                let imageView = UIImageView(frame: CGRect(x: -10, y: -10, width: 20, height: 20)) // Adjust size as needed
    //                imageView.contentMode = .scaleAspectFit
    //
    //                // Set the image for the image view using a system image
    //                let waterSymbol = UIImage(systemName: "drop.fill")
    //                imageView.image = waterSymbol
    //
    //                // Specify the light blue color you want to use and apply it to the image view
    //                let lightBlueColor = UIColor.systemBlue.withAlphaComponent(0.75) // Adjust alpha for lighter shade
    //                imageView.tintColor = lightBlueColor
    //
    //                // Add the image view to the annotation view
    //                annotationView?.addSubview(imageView)
    //            } else {
    //                // Reuse the annotation view
    //                annotationView?.annotation = annotation
    //            }
    //
    //            return annotationView
    //        }

    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //        // Check if the annotation is not the user's location
    //        if annotation is MKUserLocation {
    //            return nil
    //        }
    //
    //        if let annotation = annotation as? CustomAnnotation {
    //            let identifier = "CustomAnnotation"
    //            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
    //
    //            if annotationView == nil {
    //                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    //                annotationView?.canShowCallout = true
    //
    //                func setAnnotationIcon() {
    //                    // Create an UIImageView for the annotation view
    //                    let imageView = UIImageView(frame: CGRect(x: -10, y: -10, width: 20, height: 20)) // Adjust size as needed
    //                    imageView.contentMode = .scaleAspectFit
    //
    //                    // Set the image for the image view using a system image
    //                    let waterSymbol = UIImage(systemName: "drop.fill")
    //                    imageView.image = waterSymbol
    //
    //                    // Specify the light blue color you want to use and apply it to the image view
    //                    let lightBlueColor = UIColor.systemBlue.withAlphaComponent(0.75) // Adjust alpha for lighter shade
    //                    imageView.tintColor = lightBlueColor
    //
    //                    // Add the image view to the annotation view
    //                    annotationView?.addSubview(imageView)
    //                }
    //                setAnnotationIcon()
    //
    //                // Add an image view to the left callout accessory view.
    //                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    //                imageView.contentMode = .scaleAspectFit
    //                annotationView?.leftCalloutAccessoryView = imageView
    //
    //                if let imageURL = annotation.imageURL, let url = URL(string: imageURL) {
    //                    // Load the image asynchronously
    //                    URLSession.shared.dataTask(with: url) { data, response, error in
    //                        if let data = data, let image = UIImage(data: data) {
    //                            DispatchQueue.main.async {
    //                                // Ensure the image view is still part of the annotation view before setting the image.
    //                                (annotationView?.leftCalloutAccessoryView as? UIImageView)?.image = image
    //                            }
    //                        }
    //                    }.resume()
    //                }
    //            } else {
    //                annotationView?.annotation = annotation
    //            }
    //
    //            return annotationView
    //        }
    //
    //        return nil
    //    }

//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation {
//            return nil
//        }
//
//        if let customAnnotation = annotation as? CustomAnnotation {
//            let identifier = "CustomAnnotation"
//            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
//
//            if annotationView == nil {
//                annotationView = MKMarkerAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
//                annotationView?.canShowCallout = true
//                annotationView?.glyphTintColor = UIColor.systemBlue.withAlphaComponent(0.75) // Light blue color for glyph
//                annotationView?.glyphImage = UIImage(systemName: "drop.fill") // Custom glyph image
//
//                // Add an image view to the left callout accessory view
//                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
//                imageView.contentMode = .scaleAspectFit
//                annotationView?.leftCalloutAccessoryView = imageView
//            } else {
//                annotationView?.annotation = customAnnotation
//            }
//
//            // Load the image asynchronously for the callout accessory view
//            if let imageURL = customAnnotation.imageURL, let url = URL(string: imageURL) {
//                URLSession.shared.dataTask(with: url) { data, response, error in
//                    if let data = data, let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            (annotationView?.leftCalloutAccessoryView as? UIImageView)?.image = image
//                        }
//                    }
//                }.resume()
//            }
//
//            return annotationView
//        }
//
//        return nil
//    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        if let customAnnotation = annotation as? CustomAnnotation {
            let identifier = "CustomAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true

                // Set custom glyph image
                annotationView?.glyphImage = UIImage(systemName: "drop.fill") // Custom glyph image
                annotationView?.glyphTintColor = UIColor.systemBlue.withAlphaComponent(0.75) // Adjust as needed

                // Make marker tint color clear to ensure no default pin/marker is visible
                annotationView?.markerTintColor = UIColor.clear

                // Add an image view to the left callout accessory view for the asynchronous image load
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) // Adjust size as needed for the callout
                imageView.contentMode = .scaleAspectFit
                annotationView?.leftCalloutAccessoryView = imageView
            } else {
                annotationView?.annotation = customAnnotation
            }

            // Asynchronously load the image for the callout accessory view
            if let imageURL = customAnnotation.imageURL, let url = URL(string: imageURL) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            (annotationView?.leftCalloutAccessoryView as? UIImageView)?.image = image
                        }
                    }
                }.resume()
            }

            return annotationView
        }

        return nil
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
