import FirebaseFirestore

func updateDocument(data: [String: Any], documentID: String, completion: (() -> Void)? = nil) {
    FirestoreManager.shared.db.collection("drinkingPoints").document(documentID).setData(data, merge: true) { error in
        
        if let error = error {
            print("Error updating document: \(error.localizedDescription)")
            if let completion = completion {
                completion()
            }
        } else {
            print("Document updated successfully")
            if let completion = completion {
                completion()
            }
        }
    }
}
