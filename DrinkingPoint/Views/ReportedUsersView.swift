import SwiftUI

struct ReportedUsersView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var viewModel: ReportedUsersViewModel

    @State var showingReportedUserView = false
    @State var userUID: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Reported Users")
                    .font(.headline)
                    .padding()

                List(viewModel.reportedUsers, id: \.userUID) { user in
                    HStack {
                        Text(user.userUID)
                            .foregroundColor(.primary)
                    }
                    .onTapGesture {
                        self.userUID = user.userUID
                        showingReportedUserView = true
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        self.isPresented = false
                    }
                }
            }
            .foregroundColor(.blue)
            .sheet(isPresented: $showingReportedUserView) {
                ReportedUserView(isPresented: $showingReportedUserView, userUID: $userUID) { selectedPoint in
                    isPresented = false
                    MapViewManager.shared.goToSelectedPoint(latitude: selectedPoint.latitude, longitude: selectedPoint.longitude)
                }
            }
        }
    }
}
