import FirebaseFirestore

func deleteDocumentFromUsers(userUID: String, completion: (() -> Void)? = nil) {
    FirestoreManager.shared.db.collection("users").document(userUID).delete() { err in
        if let err = err {
            print("Error unflaging user: \(userUID) \(err)")
        }
        if let completion = completion {
            completion()
        }
    }
}
