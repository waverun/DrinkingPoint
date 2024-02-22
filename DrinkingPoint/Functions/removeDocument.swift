import FirebaseFirestore

func removeDocument(documentID: String, uniqueFileName: String, completion: (() -> Void)? = nil) {
    FirestoreManager.shared.db.collection("drinkingPoints").document(documentID).delete() { err in
        if let err = err {
            print("Error removing document: \(err)")
            if let completion = completion {
                completion()
            }
        } else {
            print("Document successfully removed!")
            deleteImage(imageRef: uniqueFileName) {
                MapViewManager.shared.signalAnnotationRemoved(documentID: documentID)
                if let completion = completion {
                    completion()
                }
            }
        }
    }
}
