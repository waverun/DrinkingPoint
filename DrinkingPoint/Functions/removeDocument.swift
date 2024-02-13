import FirebaseFirestore

func removeDocument(documentID: String, uniqueFileName: String) {
    FirestoreManager.shared.db.collection("drinkingPoints").document(documentID).delete() { err in
        if let err = err {
            print("Error removing document: \(err)")
        } else {
            print("Document successfully removed!")
//            if let point = pointsAdded.first(where: { $0.documentID == documentID }) {
//                let uniqueFileName = point.uniqueFileName
                deleteImage(imageRef: uniqueFileName)
//            }
        }
    }
}
