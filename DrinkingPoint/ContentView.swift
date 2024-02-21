import SwiftUI

struct ContentView: View {
    @StateObject private var imagePickerViewModel = ImagePickerViewModel()
    @State private var showingNavigationOptions = false
    @State private var showingReportOptions = false

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

            if showingReportOptions, let annotation = MapViewManager.shared.lastAnnotationSelected {
                ReportOptionModal(annotation: annotation, isPresented: $showingReportOptions)
            }
        }
        .sheet(isPresented: $imagePickerViewModel.isImagePickerPresented) {
            ImagePickerView(image: self.$imagePickerViewModel.image)
        }
    }
}
