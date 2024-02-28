func markUserAsBlocked(userId: String, completion: @escaping (Bool) -> Void) {
    let userDocument = FirestoreManager.shared.db.collection("users").document(userId)

//    userDocument.updateData(["isBlocked": true]) { error in
    userDocument.setData(["isBlocked": true], merge: true) { error in
        switch true {
            case error != nil:
                print("Error blocking user: \(String(describing: error))")
                completion(false)
            default:
                print("User successfully marked as blocked")
                completion(true)
        }
    }
}
