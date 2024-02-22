import SwiftUI
import Combine

class ReportedPointsViewModel: ObservableObject {
    @Published var reportedPoints: [PointAdded] = []

    func fetchReportedPoints() {
        // Simulate fetching reported points. Replace this with your actual data fetching logic.
        getDocumentsIn(fieldName: "reportReason", values: ["ic", "hb", "sm"]) { [weak self] reportedPoints in
            DispatchQueue.main.async {
                self?.reportedPoints = reportedPoints
            }
        }
    }
}
