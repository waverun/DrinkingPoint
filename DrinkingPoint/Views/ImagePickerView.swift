import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authManager: UserAuthManager

    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType = .camera

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary // Fallback to photo library
        }
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self, authManager: authManager)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerView
        var authManager: UserAuthManager // Add this

        init(_ parent: ImagePickerView, authManager: UserAuthManager) {
            self.parent = parent
            self.authManager = authManager
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image

                guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }

                guard let currentUserUID = authManager.currentUserUID else {
                    return
                }

                showUploadTermsAlert {
                    uploadImage(userUID: currentUserUID, imageData: imageData)
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
