import SwiftUI

struct ContentView: View {
    @StateObject private var imagePickerViewModel = ImagePickerViewModel()
    @StateObject private var reportedPointsViewModel = ReportedPointsViewModel() // Add this line
    @State private var showingNavigationOptions = false
    @State private var showingReportOptions = false
    @State private var showingReportedPoints = false
//    @State var reportedPoints: [PointAdded] = []

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
            ButtonsView(imagePickerViewModel: imagePickerViewModel, showingNavigationOptions: $showingNavigationOptions, showingReportOptions: $showingReportOptions, selectedAnnotation: Binding(
                    get: { MapViewManager.shared.lastAnnotationSelected },
                    set: { _ in }
                )) // Pass a binding to the ButtonsView

            // Conditionally show the modal view
            if showingNavigationOptions, let annotation = MapViewManager.shared.lastAnnotationSelected {
                NavigationOptionModal(annotation: annotation, isPresented: $showingNavigationOptions)
            }

//            if showingReportOptions, let annotation = MapViewManager.shared.lastAnnotationSelected {
//                ReportOptionModal(annotation: annotation, isPresented: $showingReportOptions) { points in
//                    // This closure is called when "Show flagged points" is selected.
//                    self.reportedPoints = points
//                    print("points:", points)
//                    self.showingReportedPoints = true // Trigger the presentation of ReportedPointsView
//                    self.showingReportOptions = false // Optionally, close the report options modal
//                }
//            }
            if showingReportOptions, let annotation = MapViewManager.shared.lastAnnotationSelected {
                ReportOptionModal(annotation: annotation, isPresented: $showingReportOptions) {_ in 
                    // Trigger fetching reported points
                    self.reportedPointsViewModel.fetchReportedPoints()
                    self.showingReportedPoints = true // Trigger the presentation of ReportedPointsView
                    self.showingReportOptions = false // Optionally, close the report options modal
                }
            }
        }
//        .sheet(isPresented: $showingReportedPoints) {
//            ReportedPointsView(isPresented: $showingReportedPoints, pointsReported: reportedPoints) { selectedPoint in
//                // Handle point selection
//            }
//        }
        .sheet(isPresented: $showingReportedPoints) {
            ReportedPointsView(isPresented: $showingReportedPoints,
                               pointsReported: $reportedPointsViewModel.reportedPoints) { selectedPoint in
                // Handle point selection
            }
        }
        .sheet(isPresented: $imagePickerViewModel.isImagePickerPresented) {
            ImagePickerView(image: self.$imagePickerViewModel.image)
        }
    }
}
