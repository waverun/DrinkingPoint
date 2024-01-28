// Add a new document with a generated ID

func addDocument(data: [String: Any], onSuccess: @escaping () -> Void) {
    //        let ref = try await FirestoreManager.shared.db.collection("users").addDocument(data: data)
    FirestoreManager.shared.db.collection("drinkingPoints").addDocument(data: data)  { error in
        if let error = error {
            print("Error adding document: \(error.localizedDescription)")
        }
        else {
            print("Document added succesffuly")
            onSuccess()
        }
    }
}
