import SwiftUI

struct ContentView: View {
    @StateObject private var imagePickerViewModel = ImagePickerViewModel()
    @StateObject private var reportedPointsViewModel = ReportedPointsViewModel() // Add this line
    @StateObject private var userPointsViewModel = UserPointsViewModel() // Add this line
    @StateObject private var reportedUsersViewModel = ReportedUsersViewModel() // Add this line
    @State private var showingNavigationOptions = false
    @State private var showingReportOptions = false
    @State private var showingReportedPoints = false
    @State private var showingUserPoints = false
    @State private var showingReportedUsers = false

    // This state is now being updated directly from MapViewManager's lastAnnotationSelected.
    var body: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all) // Set the background color for the entire view

                MapView()
                    .edgesIgnoringSafeArea(.all) // Ensure MapView expands to the available space
                    .onAppear {
                        MapViewManager.shared.onLocationSelected = { location, radius in
                            MapViewManager.shared.updateRegion(userLocation: location, radius: radius)
                        }
                    }
            ButtonsView(imagePickerViewModel: imagePickerViewModel, showingNavigationOptions: $showingNavigationOptions, showingReportOptions: $showingReportOptions, showingReportedPoints: $showingReportedPoints, showingUserPoints: $showingUserPoints, selectedAnnotation: Binding(
                    get: { MapViewManager.shared.lastAnnotationSelected },
                    set: { _ in }
                )) // Pass a binding to the ButtonsView

            // Conditionally show the modal view
            if showingNavigationOptions, let annotation = MapViewManager.shared.lastAnnotationSelected {
                NavigationOptionModal(annotation: annotation, isPresented: $showingNavigationOptions)
            }

            if showingReportOptions, let annotation = MapViewManager.shared.lastAnnotationSelected {
                ReportOptionModal(annotation: annotation, isPresented: $showingReportOptions) { showFlagedOrUserPoints in
                    // Trigger fetching reported points
                    switch showFlagedOrUserPoints {
                        case "showFlagedPoints":
                            self.reportedPointsViewModel.fetchReportedPoints()
                            self.showingReportedPoints = true // Trigger the presentation of ReportedPointsView
                        case "showUserPoints":
                            self.userPointsViewModel.fetchUserPoints()
                            showingUserPoints = true
                        case "showReportedUsers":
                            self.reportedUsersViewModel.fetchReportedUsers()
                            showingReportedUsers = true
                        default: break
                    }
                    self.showingReportOptions = false // Optionally, close the report options modal
                }
            }
        }
        .sheet(isPresented: $showingReportedPoints) {
            ReportedPointsView(isPresented: $showingReportedPoints) { selectedPoint in
                MapViewManager.shared.goToSelectedPoint(latitude: selectedPoint.latitude, longitude: selectedPoint.longitude)
            }
        }
        .sheet(isPresented: $showingReportedUsers) {
            ReportedUsersView(isPresented: $showingReportedUsers) 
//            { selectedPoint in
//                MapViewManager.shared.goToSelectedPoint(latitude: selectedPoint.latitude, longitude: selectedPoint.longitude)
//            }
        }
        .sheet(isPresented: $showingUserPoints) {
            UserPointsView(isPresented: $showingUserPoints) { selectedPoint in
                MapViewManager.shared.goToSelectedPoint(latitude: selectedPoint.latitude, longitude: selectedPoint.longitude)
            }
        }
        .sheet(isPresented: $imagePickerViewModel.isImagePickerPresented) {
            ImagePickerView(image: self.$imagePickerViewModel.image)
        }
        .environmentObject(reportedPointsViewModel)
        .environmentObject(userPointsViewModel)
        .environmentObject(reportedUsersViewModel)
    }
}
