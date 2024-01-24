import SwiftUI
//import Firebase

class ImagePickerViewModel: NSObject, ObservableObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @Published var isImagePickerPresented = false
    @Published var image: UIImage?

    func showImagePicker() {
        self.isImagePickerPresented = true
    }

    func uploadImageToFirebase() {
//        guard let imageData = image?.jpegData(compressionQuality: 0.4) else { return }

        // Create a reference to Firebase Storage
//        let storageRef = Storage.storage().reference().child("your_path_here")

        // Upload the image
//        storageRef.putData(imageData, metadata: nil) { metadata, error in
//            guard metadata != nil else {
//                // Handle the error
//                return
//            }
            // Image uploaded successfully
//        }
    }

    // UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.image = selectedImage
            uploadImageToFirebase()
        }
        self.isImagePickerPresented = false
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isImagePickerPresented = false
    }
}
