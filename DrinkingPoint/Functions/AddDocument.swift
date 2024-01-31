import FirebaseFirestore

func addDocument(data: [String: Any], onSuccess: @escaping (DocumentReference) -> Void) {
    let documentRef = FirestoreManager.shared.db.collection("drinkingPoints").document() // Get a reference to a new document
    documentRef.setData(data) { error in
        if let error = error {
            print("Error adding document: \(error.localizedDescription)")
        } else {
            print("Document added successfully with ID: \(documentRef.documentID)")
            onSuccess(documentRef)
        }
    }
}
