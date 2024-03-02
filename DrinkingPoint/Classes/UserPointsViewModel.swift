import SwiftUI
import Combine

class UserPointsViewModel: ObservableObject {
    @Published var userPoints: [PointAdded] = []

    func fetchUserPoints(userUID: String? = MapViewManager.shared.lastAnnotationSelected?.userUID, isReported: Bool = false) {
        // Simulate fetching reported points. Replace this with your actual data fetching logic.
        if let userUID = userUID {
            getDocumentsIn(fieldName: "userUID", values: [userUID]) { [weak self] isSuccessful, userPoints in
                if isSuccessful {
                    DispatchQueue.main.async {
                        self?.userPoints = userPoints.filter({userPoint in 
                            userPoint.reportReason.isEmpty == !isReported})
                    }
                }
            }
        }
    }
}
