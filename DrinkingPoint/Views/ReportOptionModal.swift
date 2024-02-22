import SwiftUI

struct ReportOptionModal: View {
    let annotation: CustomAnnotation
    @Binding var isPresented: Bool
    var onShowFlaggedPoints: ([PointAdded]) -> Void = { _ in }

    // Dynamic height adjustment based on build configuration
    var dynamicHeight: CGFloat {
#if DEBUG
        return 370 // Increased height for Debug mode to accommodate additional debug button
#else
        return 330 // Standard height for Release mode
#endif
    }

    func reportDocument(reason: String) {
        updateDocument(data: ["reportReason" : reason], documentID: annotation.documentID)
    }

    var body: some View {
        VStack {
            ZStack {
                BlurView(style: .systemMaterial) // You can choose different styles like .dark, .light, etc.
                    .frame(width: 250, height: dynamicHeight)
                    .cornerRadius(12)
                    .shadow(radius: 8)

                VStack {
                    Text("Report Content:")
                        .font(.system(size: 18, weight: .bold))
                        .padding()

                    HStack {
                        // Display the image as the title, similar to the NavigationOptionModal
                        if let imageURL = annotation.imageURL, let url = URL(string: imageURL) {
                            CachedAsyncImage(url: url)
//                                image.resizable()
//                            } placeholder: {
//                                ProgressView()
//                            }
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                        }

                        // Title
                        if let title = annotation.title {
                            Text(title)
                                .font(.headline)
                                .padding()
                                .fixedSize(horizontal: false, vertical: true) // Allows text to wrap
                                .lineLimit(nil) // Removes the line limit
                        }
                    }

                    Divider()

                    // Report Options
                    Button("Inappropriate Content") {
                        // Handle report for inappropriate content
                        print("Reported as inappropriate content")
                        reportDocument(reason: "ic")
                        isPresented = false
                    }

                    Divider()

                    Button("Harassment or Bullying") {
                        // Handle report for harassment or bullying
                        print("Reported for harassment or bullying")
                        reportDocument(reason: "hb")
                        isPresented = false
                    }

                    Divider()

                    Button("Spam or Misleading") {
                        // Handle report for spam or misleading
                        print("Reported as spam or misleading")
                        reportDocument(reason: "sm")
                        isPresented = false
                    }

                    Divider()

                    Button("Cancel") {
                        isPresented = false
                    }

#if DEBUG
                    Divider()

                    Button("Show flaged points") {
                        // Handle report for spam or misleading
                        getDocumentsIn(fieldName: "reportReason", values: ["ic","hb","sm"]) { reportedPoints in
                            self.onShowFlaggedPoints(reportedPoints)
//                            isPresented = false
                        }
                        isPresented = false
                    }
#endif
                }
                .padding()
                .frame(width: 250, height: dynamicHeight)
                .foregroundColor(.blue)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
