import SwiftUI
import CoreLocation

struct ButtonsView: View {
    var imagePickerViewModel: ImagePickerViewModel
    @State private var showingSearchView = false
    @State private var showingFilterView = false

    @Binding var showingNavigationOptions: Bool // Add this line
    @Binding var showingReportOptions: Bool // Add this line
    @Binding var showingReportedPoints: Bool // Add this line
    @Binding var selectedAnnotation: CustomAnnotation? // Add this line

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer() // Spacer before the first button

                Button(action: {
                    // Action for Button 1
                    imagePickerViewModel.showImagePicker()
                }) {
                    Image(systemName: "plus.circle")
                        .imageScale(.large) // Options: .small, .medium, .large
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 8) // Reduced vertical padding
                .padding(.horizontal, 10) // Horizontal padding for touch area
                .background(Color.black.opacity(0.25)) // Black background with low alpha
                .clipShape(Circle()) // Makes the background rounded

                Spacer() // Spacer before the first button

                Button(action: {
                    self.showingFilterView = true
                }) {
                    Image(systemName: "book")
                        .imageScale(.large) // Options: .small, .medium, .large
                        .foregroundColor(.primary)
                }
                .sheet(isPresented: $showingFilterView) {
                    FilterView(isPresented: $showingFilterView, pointsAdded: pointsAdded) { selectedPoint in
                        let location = CLLocationCoordinate2D(latitude: selectedPoint.latitude, longitude: selectedPoint.longitude)
                        LocationManager.shared.needToUpdateRegion = false
                        MapViewManager.shared.updateRegion(userLocation: location)
                    }
                }
                .padding(.vertical, 8) // Reduced vertical padding
                .padding(.horizontal, 10) // Horizontal padding for touch area
                .background(Color.black.opacity(0.25)) // Black background with low alpha
                .clipShape(Circle()) // Makes the background rounded

                Spacer() // Spacer between buttons

                Button(action: {
                    if let userLocation = LocationManager.shared.location {
                        MapViewManager.shared.updateRegion(userLocation: userLocation)
                    }
                    LocationManager.shared.needToUpdateRegion = true
                }) {
                    Image(systemName: "location.fill")
                        .imageScale(.large) // Options: .small, .medium, .large
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .background(Color.black.opacity(0.25)) // Black background with low alpha
                .clipShape(Circle()) // Makes the background rounded

                Spacer() // Spacer between buttons

                Button(action: {
                    if MapViewManager.shared.lastAnnotationSelected != nil {
                        showingNavigationOptions = true
                    }
                }) {
                    Image(systemName: "location.north.line.fill")
                        .imageScale(.large) // Options: .small, .medium, .large
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .background(Color.black.opacity(0.25)) // Black background with low alpha
                .clipShape(Circle()) // Makes the background rounded

                Spacer() // Spacer between buttons

                Button(action: {
                    if MapViewManager.shared.lastAnnotationSelected != nil {
                        showingReportOptions = true
                    } else {
                        showingReportedPoints = true
                    }
                }) {
                    Image(systemName: "flag")
                        .imageScale(.large) // Options: .small, .medium, .large
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .background(Color.black.opacity(0.25)) // Black background with low alpha
                .clipShape(Circle()) // Makes the background rounded

                Spacer() // Spacer between buttons

                Button(action: {
                    self.showingSearchView = true
                }) {
                    Image(systemName: "magnifyingglass")
                        .imageScale(.large) // Options: .small, .medium, .large
                        .foregroundColor(.primary)
                }
                .sheet(isPresented: $showingSearchView) {
                    SearchView(selectedLocation: .constant(nil)) // Bind this to a state that your MapView can listen to
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .background(Color.black.opacity(0.25)) // Black background with low alpha
                .clipShape(Circle()) // Makes the background rounded

                Spacer() // Spacer after the last button
            }
            .padding(.top, 15) // Additional padding at the bottom to push the buttons down
            .background(Color.clear) // Gray background for the entire HStack
        }
    }
}
