import SwiftUI
import CoreLocation

struct ButtonsView: View {
    var imagePickerViewModel: ImagePickerViewModel
    @State private var showingSearchView = false
    @State private var showingFilterView = false
//    @State private var showingNavigationOptions = false

    @Binding var showingNavigationOptions: Bool // Add this line
    @Binding var selectedAnnotation: CustomAnnotation? // Add this line

    var body: some View {
        HStack {
            Spacer() // Spacer before the first button

            Button(action: {
                // Action for Button 1
                imagePickerViewModel.showImagePicker()
            }) {
                Image(systemName: "plus.circle")
                    .imageScale(.large) // Options: .small, .medium, .large
            }
            .padding(.vertical, 8) // Reduced vertical padding
            .padding(.horizontal, 10) // Horizontal padding for touch area
            .foregroundColor(.white)

            Spacer() // Spacer before the first button

            Button(action: {
                self.showingFilterView = true
            }) {
                Image(systemName: "book")
                    .imageScale(.large) // Options: .small, .medium, .large
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
            .foregroundColor(.white)

            Spacer() // Spacer between buttons

            Button(action: {
                if let userLocation = LocationManager.shared.location {
                    MapViewManager.shared.updateRegion(userLocation: userLocation)
                }
                LocationManager.shared.needToUpdateRegion = true
            }) {
                Image(systemName: "location.fill")
                    .imageScale(.large) // Options: .small, .medium, .large
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .foregroundColor(.white)

            Spacer() // Spacer between buttons

            Button(action: {
                if MapViewManager.shared.lastAnnotationSelected != nil {
                    showingNavigationOptions = true
                }
            }) {
                Image(systemName: "location.north.line.fill")
                    .imageScale(.large) // Options: .small, .medium, .large
            }
//            .sheet(isPresented: $showingNavigationOptions) {
//                // Assuming you have access to the lastAnnotationSelected
//                if let lastAnnotation = MapViewManager.shared.lastAnnotationSelected {
//                    NavigationOptionModal(annotation: lastAnnotation, isPresented: $showingNavigationOptions)
//                }
//            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .foregroundColor(.white)

            Spacer() // Spacer between buttons

            Button(action: {
                self.showingSearchView = true
            }) {
                Image(systemName: "magnifyingglass")
                    .imageScale(.large) // Options: .small, .medium, .large
            }
            .sheet(isPresented: $showingSearchView) {
                SearchView(selectedLocation: .constant(nil)) // Bind this to a state that your MapView can listen to
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .foregroundColor(.white)

            Spacer() // Spacer after the last button
        }
        .padding(.top, 15) // Additional padding at the bottom to push the buttons down
        .background(Color.gray) // Gray background for the entire HStack
//        .padding(.horizontal) // Padding on the sides of the HStack
    }
}
