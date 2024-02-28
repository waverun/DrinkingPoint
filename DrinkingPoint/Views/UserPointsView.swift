import SwiftUI
import MapKit

struct UserPointsView: View {
    @Binding var isPresented: Bool
    //    @Binding var pointsReported: [PointAdded] // Change to Binding
    @EnvironmentObject var viewModel: UserPointsViewModel

    @State private var filterText: String = ""
    @State private var distanceFilter: Double? // Distance in meters
    @State private var selectedPoints: Set<String> = [] // Track selected points by their documentID
    @State private var selectAll: Bool = false // Track whether to select or deselect all

    var onPointSelected: (PointAdded) -> Void

    var filteredPoints: [PointAdded] {
        viewModel.userPoints.filter { point in
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

    private func toggleSelection(for point: PointAdded) {
        if selectedPoints.contains(point.documentID) {
            selectedPoints.remove(point.documentID)
        } else {
            selectedPoints.insert(point.documentID)
        }
    }

    private func toggleSelectAll() {
        if selectAll {
            selectedPoints.removeAll()
        } else {
            selectedPoints = Set(filteredPoints.map { $0.documentID })
        }
        selectAll.toggle()
    }

    private func reportPoints() {
        let dispatchGroup = DispatchGroup()

        // Example action for unflagging points
        for id in selectedPoints {
            // Call unflag function here
            if let point = filteredPoints.first(where: { $0.documentID == id}) {
                print("Reporting point: \(point.title)")
                dispatchGroup.enter()
                updateDocument(data: ["reportReason": "rp"], documentID: point.documentID) {
//                    let location = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
//                    removeClosePoints(location: location, uniqueFileName: point.uniqueFileName, dispatchGroup: dispatchGroup)
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            // All updates are complete, now fetch the latest data
            viewModel.fetchUserPoints()
        }
    }

//    private func unflagPoints() {
//        let dispatchGroup = DispatchGroup()
//
//        // Example action for unflagging points
//        for id in selectedPoints {
//            // Call unflag function here
//            if let point = filteredPoints.first(where: { $0.documentID == id}) {
//                print("Unflagging point: \(point.title)")
//                dispatchGroup.enter()
//                updateDocument(data: ["reportReason": ""], documentID: point.documentID) {
//                    let location = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
//                    removeClosePoints(location: location, uniqueFileName: point.uniqueFileName, dispatchGroup: dispatchGroup)
//                    dispatchGroup.leave()
//                }
//            }
//        }
//        dispatchGroup.notify(queue: .main) {
//            // All updates are complete, now fetch the latest data
//            viewModel.fetchReportedPoints()
//        }
//    }

    private func reportUser() {
        guard let lastAnnotationSelected = MapViewManager.shared.lastAnnotationSelected else { return }
        let userUID = lastAnnotationSelected.userUID
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        markUserAsBlocked(userId: userUID) { isSuccessful in
            guard isSuccessful,
                let userUID = MapViewManager.shared.lastAnnotationSelected?.userUID else {
                dispatchGroup.leave()
                return
            }

            getDocumentsIn(fieldName: "userUID", values: [userUID]) { isSuccessful, userPoints in
                guard isSuccessful else {
                    dispatchGroup.leave()
                    return
                }
                for userPoint in userPoints {
                    dispatchGroup.enter()
                    updateDocument(data: ["reportReason":"ru"], documentID: userPoint.documentID) {
                        dispatchGroup.leave()
                    }
                }
                dispatchGroup.leave()
            }
        }
        // Example action for deleting points
//        for id in selectedPoints {
//            // Call delete function here
//            if let point = filteredPoints.first(where: { $0.documentID == id}) {
//                dispatchGroup.enter()
//                print("Deleting point: \(point.title)")
//                removeDocument(documentID: point.documentID, uniqueFileName: point.uniqueFileName) {
//                    dispatchGroup.leave()
//                }
//            }
//        }
        dispatchGroup.notify(queue: .main) {
            // All updates are complete, now fetch the latest data
            viewModel.fetchUserPoints()
        }
    }

//    private func deletePoints() {
//        let dispatchGroup = DispatchGroup()
//
//        // Example action for deleting points
//        for id in selectedPoints {
//            // Call delete function here
//            if let point = filteredPoints.first(where: { $0.documentID == id}) {
//                dispatchGroup.enter()
//                print("Deleting point: \(point.title)")
//                removeDocument(documentID: point.documentID, uniqueFileName: point.uniqueFileName) {
//                    dispatchGroup.leave()
//                }
//            }
//        }
//        dispatchGroup.notify(queue: .main) {
//            // All updates are complete, now fetch the latest data
//            viewModel.fetchUserPoints()
//        }
//    }

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

                HStack(spacing: 10) {
                    Button("Report Points") {
                        showReportPointsAlert(numberOfTagedPoints: selectedPoints.count) {
                            reportPoints()
                        }
                    }
                    .padding(.vertical, 10) // Add padding inside the button for height
                    .padding(.horizontal, 20) // Add padding inside the button for width
                    .foregroundColor(.white) // Set the text color
                    .background(Color.blue) // Set the background color
                    .cornerRadius(10) // Rounded edges

                    Spacer()

                    Button("Report User") {
                        showReportUserAlert() {
                            reportUser()
                        }
                    }
                    .padding(.vertical, 10) // Add padding inside the button for height
                    .padding(.horizontal, 20) // Add padding inside the button for width
                    .foregroundColor(.white) // Set the text color
                    .background(Color.blue) // Set the background color
                    .cornerRadius(10) // Rounded edges
                }

                .padding(.horizontal)
                .padding(.top)

                HStack {
                    Button(selectAll ? "Uncheck All" : "Check All") {
                        toggleSelectAll()
                    }
                    .foregroundColor(.blue) // Apply color to make it look like text only
                    .padding(.leading, 5) // Ensure it's aligned close to the list items

                    Spacer() // Pushes the button to the left
                }
                .padding(.top, 10)
                .padding(.leading, 15)

                List(filteredPoints, id: \.documentID) { point in
                    HStack {

                        Image(systemName: selectedPoints.contains(point.documentID) ? "checkmark.square" : "square")
                            .onTapGesture {
                                toggleSelection(for: point)
                            }

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
            .navigationTitle("All user Points")
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

