import SwiftUI

struct NavigationOptionModal: View {
    let annotation: CustomAnnotation
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            ZStack {
//                 Use BlurView as the background
                BlurView(style: .systemMaterial) // You can choose different styles like .dark, .light, etc.
//                .padding()
                .frame(width: 250, height: 300)
                .cornerRadius(12)
                .shadow(radius: 8)

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
                                .fixedSize(horizontal: false, vertical: true) // Allows text to wrap
                                .lineLimit(nil) // Removes the line limit
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

                .padding()
                .frame(width: 250, height: 300)
//                .background(Color.white)
//                .cornerRadius(12)
//                .shadow(radius: 8)
                .foregroundColor(.blue)
            }
            // Use clipShape to apply the rounded corners to the entire ZStack, including the BlurView
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
