import SwiftUI
import CoreLocation

struct ButtonsView: View {
    var imagePickerViewModel: ImagePickerViewModel
    @State private var showingSearchView = false
    @State private var showingFilterView = false
    @State private var showingLoginActionSheet = false
    @State private var showingSignUpView = false

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
                    self.showingLoginActionSheet = true
                }) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .imageScale(.large) // Options: .small, .medium, .large
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 8) // Reduced vertical padding
                .padding(.horizontal, 10) // Horizontal padding for touch area
                .background(Color.black.opacity(0.25)) // Black background with low alpha
                .clipShape(Circle()) // Makes the background rounded
                .actionSheet(isPresented: $showingLoginActionSheet) {
                    ActionSheet(title: Text("Login Options"),
                                message: Text("Choose your login method."),
                                buttons: [
                                    .default(Text("Add User/Password Account")) {
                                        self.showingSignUpView = true
                                    },
                                    .default(Text("Login with Google")) {
                                        // Handle Login with Google action
                                    },
                                    .default(Text("Login with Apple")) {
                                        // Handle Login with Apple action
                                    },
                                    .cancel()
                                ])
                }
                .sheet(isPresented: $showingSignUpView) {
                    SignUpView() // Assuming SignUpView is your sign-up view
                }

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
//                        let location = CLLocationCoordinate2D(latitude: selectedPoint.latitude, longitude: selectedPoint.longitude)
//                        LocationManager.shared.needToUpdateRegion = false
//                        MapViewManager.shared.updateRegion(userLocation: location)
                        MapViewManager.shared.goToSelectedPoint(latitude: selectedPoint.latitude, longitude: selectedPoint.longitude)
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
                        #if DEBUG
                        showingReportedPoints = true
                        #endif
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
