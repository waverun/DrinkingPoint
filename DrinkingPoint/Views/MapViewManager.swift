import SwiftUI
import MapKit

class MapViewManager: NSObject, MKMapViewDelegate {
    static let shared = MapViewManager()

    private override init() {}

    lazy var mapView: MKMapView = {
        let map = MKMapView(frame: .zero)
        map.delegate = self // Set delegate to self
        map.showsUserLocation = true
        // Other setup...
        return map
    }()

    var closeImageButton: UIButton?
    var openImageAnnotation: MKAnnotation?
    var onLocationSelected: ((CLLocationCoordinate2D, CLLocationDistance) -> Void)?
    var lastRegionUsedForListener: MKCoordinateRegion?
    var lastAnnotationSelected: CustomAnnotation?

    func goToSelectedPoint(latitude: Double, longitude: Double) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        LocationManager.shared.needToUpdateRegion = false
        updateRegion(userLocation: location)
    }

    func signalAnnotationRemoved(documentID: String) {
        if let lastAnnotationSelected = lastAnnotationSelected,
           lastAnnotationSelected.documentID == documentID {
            self.lastAnnotationSelected = nil
        }
    }

    func makeMapView() -> MKMapView {
        if let region = lastRegionUsedForListener {
            addSnapshotListener(forRegion: region)
        }
        return mapView
    }

    func updateMapView(_ mapView: MKMapView, with userLocation: CLLocationCoordinate2D?) {
        if let userLocation = userLocation {
            updateRegion(userLocation: userLocation)
        }
    }

    func updateRegion(userLocation: CLLocationCoordinate2D, radius: CLLocationDistance = 500) {
        lastRegionUsedForListener = MKCoordinateRegion(center: userLocation, latitudinalMeters: radius, longitudinalMeters: radius)
        mapView.setRegion(lastRegionUsedForListener!, animated: true)
    }

    func addAnnotation(at coordinate: CLLocationCoordinate2D, withTitle title: String, imageURL: String, documentID: String, userUID: String) {
        var title = title
        if title.isEmpty {
            title = "Water"
        }
        let annotation = CustomAnnotation(coordinate: coordinate, title: title, imageURL: imageURL, documentID: documentID, userUID: userUID)
        DispatchQueue.main.async { [weak self] in
            self?.mapView.addAnnotation(annotation)
        }
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        if let customAnnotation = annotation as? CustomAnnotation {
            let identifier = "CustomAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

            func setAnnotationView() {
                    annotationView = MKMarkerAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true

                    // Make marker tint color clear
                    annotationView?.glyphTintColor = UIColor.systemBlue.withAlphaComponent(0.75) // Light blue color for glyph
                    annotationView?.glyphImage = UIImage(systemName: "drop.fill") // Custom glyph image
                    annotationView?.markerTintColor = UIColor.clear

                    // Use a button as the callout accessory view
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                    button.contentMode = .scaleAspectFit
                    button.isUserInteractionEnabled = true // Button is interactive by default

                    // Asynchronously load the image for the button
//                    if let imageURL = customAnnotation.imageURL, let url = URL(string: imageURL) {
//                        URLSession.shared.dataTask(with: url) { data, response, error in
//                            if let data = data, let image = UIImage(data: data) {
//                                DispatchQueue.main.async {
//                                    button.setImage(image, for: .normal)
//                                }
//                            }
//                        }.resume()
//                    }

                if let imageURL = customAnnotation.imageURL, let url = URL(string: imageURL) {
                    fetchImage(for: url) { image in
                        button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                    }
                }
                annotationView?.leftCalloutAccessoryView = button
            }
            setAnnotationView()

            return annotationView
        }

        return nil
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        // Check if lastRegionUsedForListener is significantly different from mapView.region
        guard let lastRegion = lastRegionUsedForListener else {
            // No last region, so set up the listener and store the current region
            addSnapshotListener(forRegion: mapView.region)
            lastRegionUsedForListener = mapView.region
            return
        }
        // Determine if the change is significant enough to warrant updating the listener
        // This can be done by comparing the center coordinates and/or the span
        let significantChange = hasRegionChangedSignificantly(lastRegion, mapView.region)

        if significantChange {
            addSnapshotListener(forRegion: mapView.region)
            lastRegionUsedForListener = mapView.region
        }
    }

    func hasRegionChangedSignificantly(_ oldRegion: MKCoordinateRegion, _ newRegion: MKCoordinateRegion) -> Bool {
        // Implement logic to determine if the change between oldRegion and newRegion is significant
        // This could be a simple distance check between the centers and/or a comparison of the spans
        let centerChange = distanceBetween(oldRegion.center, newRegion.center)
        let spanChange = fabs(oldRegion.span.latitudeDelta - newRegion.span.latitudeDelta) > 0.001 || fabs(oldRegion.span.longitudeDelta - newRegion.span.longitudeDelta) > 0.001

        return centerChange > 50 || spanChange // Example threshold, adjust based on your needs
    }

    func distanceBetween(_ coordinate1: CLLocationCoordinate2D, _ coordinate2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
        let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)

        return location1.distance(from: location2)
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let image = (control as? UIButton)?.image(for: .normal) {
            // Now you have access to the image and the annotation
            presentFullSizeImage(image: image)
        }
    }

//    @objc func annotationCalloutTapped(_ sender: UITapGestureRecognizer) {
//        if let annotationView = sender.view as? MKAnnotationView,
//           let customAnnotation = annotationView.annotation as? CustomAnnotation,
//           let image = customAnnotation.image {
//            // Present the full-sized image
//            presentFullSizeImage(image: image)
//        }
//    }

    func removeAllAnnotations(byImageUrl imageURL: String) {
        let annotationsToRemove = mapView.annotations.filter { annotation in
            // Check if the annotation's coordinate matches the target latitude and longitude
            if let customAnnotation = annotation as? CustomAnnotation {
                return customAnnotation.imageURL == imageURL
            }
            return false
        }

        // Remove the filtered annotations from the map view
        if closeImageButton == nil,
           let openImageAnnotation = openImageAnnotation,
           !annotationsToRemove.contains(where: { $0 === openImageAnnotation } ) {
            mapView.removeAnnotations(annotationsToRemove)
            return
        }

        if let closeImageButton = closeImageButton {
            dismissOverlayViewBeforeRemovAnnotation(sender: closeImageButton) { [weak self] in
                self?.mapView.removeAnnotations(annotationsToRemove)
                self?.closeImageButton = nil
                self?.openImageAnnotation = nil
            }
            return
        }
        mapView.removeAnnotations(annotationsToRemove)
    }

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
                closeImageButton = closeButton
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

    func dismissOverlayViewBeforeRemovAnnotation(sender: UIButton, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.3, animations: {
            sender.superview?.alpha = 0
        }) { [weak self] completed in
            sender.superview?.removeFromSuperview()
            self?.closeImageButton = nil
            completion()
        }
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }

        // Perform any actions you need when the callout is about to be shown.
        // For example, you might want to store the selected annotation,
        // update some UI elements, or log some information.
        // If you need to track the opening of a specific annotation's callout,
        // you can check if the annotation is one of your custom annotations.
        if let customAnnotation = annotation as? CustomAnnotation {
            print("Callout for annotation '\(customAnnotation.title ?? "")' is about to be shown.")

            // Now you have access to your custom annotation,
            // and you can perform actions specific to it.
            lastAnnotationSelected = customAnnotation
            // Additional custom logic for when a specific annotation's callout is selected...
        }
    }

    func fetchImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSURL(string: url.absoluteString)!

        // Check cache first
        if let cachedImage = ImageCache.shared.image(for: cacheKey) {
            completion(cachedImage)
            return
        }

        // Load from network
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            DispatchQueue.main.async {
                ImageCache.shared.setImage(downloadedImage, for: cacheKey)
                completion(downloadedImage)
            }
        }.resume()
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
