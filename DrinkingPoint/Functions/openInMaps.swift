import MapKit

func openInAppleMaps(latitude: Double, longitude: Double) {
    let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
    mapItem.name = "Destination"
    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
}

func openInGoogleMaps(latitude: Double, longitude: Double) {
    if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving"),
       UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
    } else if let url = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(latitude),\(longitude)&travelmode=driving") {
        UIApplication.shared.open(url)
    }
}
