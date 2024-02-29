import SwiftUI

struct ReportedUsersView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var viewModel: ReportedUsersViewModel

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
                        // Navigate to ReportedUserAndPointsView with selected user
                        // Assuming ReportedUserAndPointsView takes a ReportedUser as an init parameter
                        // NavigationLink(destination: ReportedUserAndPointsView(user: user)) {
                        //     EmptyView()
                        // }.hidden()
                        // Note: Actual navigation or modal presentation logic may vary
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
        }
    }
}
