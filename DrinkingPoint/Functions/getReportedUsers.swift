func getReportedUsers(completion: @escaping ([ReportedUser]) -> Void) {
    var users: [ReportedUser] = []

    FirestoreManager.shared.db.collection("users")
        .whereField("isBlocked", isEqualTo: true)
        .getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print("getReportedUsers error: " + error!.localizedDescription)
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                completion([])
                return
            }

            users = documents.compactMap { queryDocumentSnapshot -> ReportedUser? in
                let userUID = queryDocumentSnapshot.documentID
//                guard let userUID = data["userUID"] as? String, let email = data["email"] as? String else {
//                    return nil
//                }
                return ReportedUser(userUID: userUID)
            }
            completion(users)
        }
}
