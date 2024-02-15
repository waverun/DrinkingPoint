import SwiftUI
import MapKit

struct FilterView: View {
    @Binding var isPresented: Bool
    @State private var filterText: String = ""
    var pointsAdded: [PointAdded]
    var onPointSelected: (PointAdded) -> Void

    var filteredPoints: [PointAdded] {
        pointsAdded.filter { point in
            filterText.isEmpty || point.title.localizedCaseInsensitiveContains(filterText)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                TextField("Filter points", text: $filterText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                List(filteredPoints, id: \.documentID) { point in
                    HStack {
//                        AsyncImage(url: URL(string: point.imageURL)) { image in
//                            image.resizable()
//                        } placeholder: {
//                            ProgressView()
//                        }
                        CachedAsyncImage(url: URL(string: point.imageURL)!)
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)

                        Text(point.title)
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
//            .searchable(text: $filterText, prompt: "Filter points")
            .foregroundColor(.blue)
        }
    }
}
