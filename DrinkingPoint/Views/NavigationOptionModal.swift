import SwiftUI

struct NavigationOptionModal: View {
    let annotation: CustomAnnotation
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("Navigate to:")
                .font(.system(size: 18, weight: .bold)) // Adjust the font size as needed
                .padding()

            HStack {
                // AsyncImage introduced in iOS 15.0 for async loading.
                if let imageURL = annotation.imageURL, let url = URL(string: imageURL) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
                }

                // Title
                if let title = annotation.title {
                    Text(title)
                        .font(.headline)
                        .padding()
                }
            }

            Divider()

            // Navigation Buttons
            Button("Open in Apple Maps") {
                openInAppleMaps(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                isPresented = false
            }

            Divider()

            Button("Open in Google Maps") {
                openInGoogleMaps(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                isPresented = false
            }

            Divider()

            Button("Cancel") {
                isPresented = false
            }
        }
//        .padding()
//        .frame(width: 250, height: 300)
//        .background(Color.white.opacity(0.6)) // Semi-transparent white background
//        .cornerRadius(12)
//        .shadow(radius: 8)
//        .foregroundColor(.blue)
//        // The following modifier centers the modal in the ZStack.
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.black.opacity(0.4)) // Semi-transparent background for the rest of the screen
//        .edgesIgnoringSafeArea(.all) // Makes the semi-transparent background extend to the edges

        .padding()
        .frame(width: 250, height: 300)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 8)
        .foregroundColor(.blue)
    }
}
