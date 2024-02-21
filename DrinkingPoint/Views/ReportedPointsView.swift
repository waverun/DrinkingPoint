import SwiftUI
import MapKit

struct ReportedPointsView: View {
    @Binding var isPresented: Bool
    @State private var filterText: String = ""
    @State private var distanceFilter: Double? // Distance in meters
    var pointsReported: [PointAdded]
    var onPointSelected: (PointAdded) -> Void

    var filteredPoints: [PointAdded] {
        pointsReported.filter { point in
            // Filter by title
            let titleMatch = filterText.isEmpty || point.title.localizedCaseInsensitiveContains(filterText)

            // Filter by distance if distanceFilter is set
            if let distanceFilter = distanceFilter, let userLocation = LocationManager.shared.location {
                let pointDistance = calculateDistance(lat1: userLocation.latitude, lon1: userLocation.longitude, lat2: point.latitude, lon2: point.longitude)
                return titleMatch && pointDistance <= distanceFilter
            } else {
                return titleMatch
            }
        }
    }

    // Function to calculate distance between two points in meters
    private func calculateDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let coordinate1 = CLLocation(latitude: lat1, longitude: lon1)
        let coordinate2 = CLLocation(latitude: lat2, longitude: lon2)
        return coordinate1.distance(from: coordinate2) // Distance in meters
    }

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Filter points", text: $filterText)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)

                    TextField("Max distance (m)", value: $distanceFilter, format: .number)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                List(filteredPoints, id: \.documentID) { point in
                    HStack {
                        CachedAsyncImage(url: URL(string: point.imageURL)!)
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)

                        Text(point.title + " " + distanceWithUnits(for: point))
                            .foregroundColor(.primary) // Ensures that text color adapts to light/dark mode
                    }
                    .onTapGesture {
                        self.onPointSelected(point)
                        self.isPresented = false
                    }
                }
            }
            .navigationTitle("Select a Point")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        self.isPresented = false
                    }
                }
            }
            .foregroundColor(.blue)
        }
    }
}

