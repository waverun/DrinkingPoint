import FirebaseFirestore

func updateDocument(data: [String: Any], documentID: String) {
    FirestoreManager.shared.db.collection("drinkingPoints").document(documentID).setData(data, merge: true) { error in
        
        if let error = error {
            print("Error updating document: \(error.localizedDescription)")
        } else {
            print("Document updated successfully")
        }
    }
}
