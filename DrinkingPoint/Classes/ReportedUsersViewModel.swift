import Foundation
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
}
