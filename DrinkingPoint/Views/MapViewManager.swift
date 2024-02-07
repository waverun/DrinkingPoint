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
        DispatchQueue.main.async { [weak self] in
            self?.mapView.addAnnotation(annotation)
        }
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

//            if annotationView == nil {
//                annotationView = MKMarkerAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
//                annotationView?.canShowCallout = true
//
//                // Set custom glyph image
//                annotationView?.glyphImage = UIImage(systemName: "drop.fill") // Custom glyph image
//                annotationView?.glyphTintColor = UIColor.systemBlue.withAlphaComponent(0.75) // Adjust as needed
//
//                // Make marker tint color clear to ensure no default pin/marker is visible
//                annotationView?.markerTintColor = UIColor.clear
//
//                // Add an image view to the left callout accessory view for the asynchronous image load
//                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50)) // Adjust size as needed for the callout
//                imageView.contentMode = .scaleAspectFit
//                annotationView?.leftCalloutAccessoryView = imageView
//
//            } else {
//                annotationView?.annotation = customAnnotation
//            }
// Asynchronously load the image for the callout accessory view
//            if let imageURL = customAnnotation.imageURL, let url = URL(string: imageURL) {
//                URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
//                    if let data = data, let image = UIImage(data: data) {
//                        DispatchQueue.main.async {
//                            (annotationView?.leftCalloutAccessoryView as? UIImageView)?.image = image
//                            customAnnotation.image = image
//
//                            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self?.annotationCalloutTapped))
//                            annotationView?.leftCalloutAccessoryView?.addGestureRecognizer(tapGesture)
//                            annotationView?.leftCalloutAccessoryView?.isUserInteractionEnabled = true
//                        }
//                    }
//                }.resume()
//            }

            func setAnnotationView() {
                if annotationView == nil {
                    annotationView = MKMarkerAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true

                    // Make marker tint color clear
                    annotationView?.markerTintColor = UIColor.clear

                    // Use a button as the callout accessory view
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                    button.contentMode = .scaleAspectFit
                    button.isUserInteractionEnabled = true // Button is interactive by default

                    // Asynchronously load the image for the button
                    if let imageURL = customAnnotation.imageURL, let url = URL(string: imageURL) {
                        URLSession.shared.dataTask(with: url) { data, response, error in
                            if let data = data, let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    button.setImage(image, for: .normal)
                                }
                            }
                        }.resume()
                    }

                    annotationView?.leftCalloutAccessoryView = button
                } else {
                    annotationView?.annotation = customAnnotation
                }
            }
            setAnnotationView()

            return annotationView
        }

        return nil
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if let customAnnotation = view.annotation as? CustomAnnotation,
        if let image = (control as? UIButton)?.image(for: .normal) {
            // Now you have access to the image and the annotation
            presentFullSizeImage(image: image)
        }
    }

    @objc func annotationCalloutTapped(_ sender: UITapGestureRecognizer) {
        if let annotationView = sender.view as? MKAnnotationView,
           let customAnnotation = annotationView.annotation as? CustomAnnotation,
           let image = customAnnotation.image {
            // Present the full-sized image
            presentFullSizeImage(image: image)
        }
    }

//    func presentFullSizeImage(image: UIImage, title: String) {
//        if let topViewController = UIViewController.getTopViewController() {
//            // Load and display the full-sized image
//            // This could be a custom view controller or a UIImageView in a UIAlertController
//            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
//            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 250, height: 250)) // Larger size
//            imageView.contentMode = .scaleAspectFit
//
////            URLSession.shared.dataTask(with: url) { data, response, error in
////                if let data = data, let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        imageView.image = image
//                        alertController.view.addSubview(imageView)
//                        topViewController.present(alertController, animated: true)
//                    }
////                }
////            }.resume()
//
//            let okAction = UIAlertAction(title: "OK", style: .default)
//            alertController.addAction(okAction)
//        }
//    }

    func presentFullSizeImage(image: UIImage) {
        if let topViewController = UIViewController.getTopViewController() {
            // Create the overlay view
            let overlayView = UIView()
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            overlayView.frame = topViewController.view.bounds
            overlayView.alpha = 0 // Start transparent for animation

            // Create the image view
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.layer.cornerRadius = 8
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false

            // Add the image view to the overlay
            overlayView.addSubview(imageView)

            // Constraints for imageView - centering it and setting max dimensions
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor, constant: -20), // Adjusted to make space for the button below
                imageView.widthAnchor.constraint(lessThanOrEqualToConstant: 350),
                imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 350),
                imageView.widthAnchor.constraint(lessThanOrEqualTo: overlayView.widthAnchor, multiplier: 0.8),
                imageView.heightAnchor.constraint(lessThanOrEqualTo: overlayView.heightAnchor, multiplier: 0.8)
            ])

            // Close Button
            func addCloseButton() {
                var config = UIButton.Configuration.filled()
                config.baseBackgroundColor = .white.withAlphaComponent(0.125)
                config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)

                // Adjust the font size of the button title
                config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                    var outgoing = incoming
                    outgoing.font = UIFont.systemFont(ofSize: 20) // Adjust the font size here
                    return outgoing
                }

                // Set the button's title
                config.title = "Close"

                let closeButton = UIButton(configuration: config, primaryAction: nil)
                closeButton.layer.cornerRadius = 15
                closeButton.layer.masksToBounds = true

                closeButton.translatesAutoresizingMaskIntoConstraints = false
                overlayView.addSubview(closeButton)

                NSLayoutConstraint.activate([
                    closeButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
                    closeButton.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor)
                ])

                closeButton.addTarget(self, action: #selector(dismissOverlayView), for: .touchUpInside)
            }

            addCloseButton()
            // Add the overlay to the view controller's view
            topViewController.view.addSubview(overlayView)

            // Animate the overlay to fade in
            UIView.animate(withDuration: 0.3) {
                overlayView.alpha = 1
            }
        }
    }

    @objc func dismissOverlayView(sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            sender.superview?.alpha = 0
        }) { completed in
            sender.superview?.removeFromSuperview()
        }
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
