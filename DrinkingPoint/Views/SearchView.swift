import SwiftUI
import MapKit

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @State private var query: String = ""
    @State private var searchResults: [MKMapItem] = []

    var body: some View {
        NavigationView {
            List(searchResults, id: \.self) { item in
                Button(action: {
                    self.selectedLocation = item.placemark.coordinate
                    MapViewManager.shared.onLocationSelected?(item.placemark.coordinate)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    VStack(alignment: .leading) {
                        Text(item.name ?? "")
                        Text(item.placemark.title ?? "").font(.subheadline).foregroundColor(.gray)
                    }
                }
            }
            .navigationBarTitle(Text("Search Location"), displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                self.presentationMode.wrappedValue.dismiss()
            })
            .searchable(text: $query)
            .onChange(of: query) { oldValue, newValue in
                search(query: newValue)
            }
        }
    }

    private func search(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                print("Search error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.searchResults = response.mapItems
        }
    }
}
