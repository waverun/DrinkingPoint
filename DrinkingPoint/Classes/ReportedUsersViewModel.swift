import Foundation
//import SwiftUI
import Combine
import Firebase

class ReportedUsersViewModel: ObservableObject {
    @Published var reportedUsers: [ReportedUser] = []

    init() {
        fetchReportedUsers()
    }

    func fetchReportedUsers() {
        getReportedUsers { [weak self] users in
            DispatchQueue.main.async {
                self?.reportedUsers = users
            }
        }
    }
}

struct ReportedUser {
    var userUID: String
//    var email: String
}

//// Example SwiftUI View to display reported users
//struct ReportedUsersView: View {
//    @ObservedObject var viewModel = ReportedUsersViewModel()
//
//    var body: some View {
//        List(viewModel.reportedUsers, id: \.userUID) { user in
//            VStack(alignment: .leading) {
//                Text("UID: \(user.userUID)")
//                Text("Email: \(user.email)")
//            }
//        }
//    }
//}
