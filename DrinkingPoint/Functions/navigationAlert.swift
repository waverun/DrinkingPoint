import SwiftUI

func navigationAlert() -> Alert {
    return Alert(
        title: Text("Navigate to"),
        message: Text(MapViewManager.shared.lastAnnotationSelected?.title ?? "Unknown Location"),
        primaryButton: .default(Text("Open in Apple Maps"), action: {
            // Call function to open in Apple Maps
            if let annotation = MapViewManager.shared.lastAnnotationSelected {
                openInAppleMaps(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            }
        }),
        secondaryButton: .default(Text("Open in Google Maps"), action: {
            // Call function to open in Google Maps
            if let annotation = MapViewManager.shared.lastAnnotationSelected {
                openInGoogleMaps(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            }
        })
    )
}
