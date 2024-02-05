import FirebaseFirestore

func removeDocument(documentID: String) {
    FirestoreManager.shared.db.collection("cities").document(documentID).delete() { err in
        if let err = err {
            print("Error removing document: \(err)")
        } else {
            print("Document successfully removed!")
        }
    }
}
