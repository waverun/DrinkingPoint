import SwiftUI
//import Firebase

class ImagePickerViewModel: NSObject, ObservableObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @Published var isImagePickerPresented = false
    @Published var image: UIImage?

    func showImagePicker() {
        self.isImagePickerPresented = true
    }

//    func uploadImageToFirebase() {
//        guard let imageData = image?.jpegData(compressionQuality: 0.4) else { return }
//
//        showUploadTermsAlert() {
//            uploadImage(imageData: imageData)
//            self.isImagePickerPresented = false
//        }
//    }

//    // UIImagePickerControllerDelegate methods
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        if let selectedImage = info[.originalImage] as? UIImage {
//            self.image = selectedImage
//            uploadImageToFirebase()
//        }
//    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.isImagePickerPresented = false
    }
}
