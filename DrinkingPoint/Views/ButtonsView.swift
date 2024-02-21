//import SwiftUI
//import CoreLocation
//
//struct ButtonsView: View {
//    var imagePickerViewModel: ImagePickerViewModel
//    @State private var showingSearchView = false
//    @State private var showingFilterView = false
//
//    @Binding var showingNavigationOptions: Bool
//    @Binding var selectedAnnotation: CustomAnnotation?
//
//    // Determine device type based on screen height
//    private var isLargeDevice: Bool {
//        UIScreen.main.bounds.height >= 1024
//    }
//
//    var body: some View {
//        HStack {
//            Spacer() // Use a leading spacer to push content toward the center
//
//            Button(action: {
//                imagePickerViewModel.showImagePicker()
//            }) {
//                Image(systemName: "plus.circle")
//                    .imageScale(.large)
//            }
//            .foregroundColor(.white)
//
//            Spacer() // Spacer between buttons to distribute them evenly
//
//            Button(action: {
//                self.showingFilterView = true
//            }) {
//                Image(systemName: "book")
//                    .imageScale(.large)
//            }
//            .sheet(isPresented: $showingFilterView) {
//                FilterView(isPresented: $showingFilterView, pointsAdded: pointsAdded) { selectedPoint in
//                    let location = CLLocationCoordinate2D(latitude: selectedPoint.latitude, longitude: selectedPoint.longitude)
//                    LocationManager.shared.needToUpdateRegion = false
//                    MapViewManager.shared.updateRegion(userLocation: location)
//                }
//            }
//            .foregroundColor(.white)
//
//            Spacer() // Repeat spacer for even distribution
//
//            Button(action: {
//                if let userLocation = LocationManager.shared.location {
//                    MapViewManager.shared.updateRegion(userLocation: userLocation)
//                }
//            }) {
//                Image(systemName: "location.fill")
//                    .imageScale(.large)
//            }
//            .foregroundColor(.white)
//
//            Spacer() // Even distribution
//
//            Button(action: {
//                if MapViewManager.shared.lastAnnotationSelected != nil {
//                    showingNavigationOptions = true
//                }
//            }) {
//                Image(systemName: "location.north.line.fill")
//                    .imageScale(.large)
//            }
//            .foregroundColor(.white)
//
//            Spacer() // Even distribution
//
//            Button(action: {
//                self.showingSearchView = true
//            }) {
//                Image(systemName: "magnifyingglass")
//                    .imageScale(.large) // Options: .small, .medium, .large
//            }
//            .sheet(isPresented: $showingSearchView) {
//                SearchView(selectedLocation: .constant(nil)) // Bind this to a state that your MapView can listen to
//            }
//            .foregroundColor(.white)
//
//            Spacer() // Use a trailing spacer to ensure even distribution
//        }
//        .padding(.vertical, isLargeDevice ? 15 : 8) // Adjust vertical padding based on device size
//        .padding(.horizontal, 20) // Apply horizontal padding to avoid edge compression
//        .background(Color.gray)
//        .fixedSize(horizontal: false, vertical: true)
//    }
//}


import SwiftUI
import CoreLocation

struct ButtonsView: View {
    var imagePickerViewModel: ImagePickerViewModel
    @State private var showingSearchView = false
    @State private var showingFilterView = false

    @Binding var showingNavigationOptions: Bool // Add this line
    @Binding var showingReportOptions: Bool // Add this line
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
