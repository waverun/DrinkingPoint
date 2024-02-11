import SwiftUI

struct ButtonsView: View {
    var imagePickerViewModel: ImagePickerViewModel
    @State private var showingSearchView = false

    var body: some View {
        HStack {
            Spacer() // Spacer before the first button

            Button(action: {
                // Action for Button 1
                imagePickerViewModel.showImagePicker()
            }) {
                Image(systemName: "plus.circle")
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
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .foregroundColor(.white)

            Spacer() // Spacer between buttons

            Button(action: {
                self.showingSearchView = true
            }) {
                Image(systemName: "magnifyingglass")
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
