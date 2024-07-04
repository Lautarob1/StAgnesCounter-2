//
//  TestConnecView.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 5/4/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore



struct TestConnecView: View {
//    FirebaseApp.configure()

    let db = Firestore.firestore()
    let usherList = [
        ["Gilberto", "Castro", "305 632 6489"],
        ["Amelita", "Courney", "786 376 5565"],
        ["Fernando", "Echeverri", "305 458 6101"],
        ["Carlos", "Kubler", "305 632 3116"],
        ["Jose Felix", "Rivas", "305 776 6632"],
        ["Gonzalo", "Lauria", "305 632 3116"],
        ["Marco", "Rojas", "305 753 1779"],
        ["Estuardo", "Figueroa", "786 683 0713"],
        ["Victor", "Unda", "954 609 9130"],
        ["Alexis", "Martinez", "561 255 8096"],
        ["Alberto", "Pontonio", "786 503 3116"]
    ]

    var body: some View {
        Button("Test Connec") {
//            addUser1(userFirst: "John", userLast: "Doe", userPh: "786 479 5322")
// use this to add users to the data base. Update userlist to avoid dups
            addUshersWithNoDelay(usherList)
          
        }
        Button("Query Mass DataBase") {
            fetchDateMasses(date: Date())
        }
        .padding(.vertical, 30)
    }
    
    func addUser(userFirst: String, userLast: String) {
        // Get a reference to the Firestore database
        let db = Firestore.firestore()
        
        // Create a new document in the "usher" collection
        db.collection("ushers").addDocument(data: [
            "user_first": userFirst,
            "user_last": userLast,
            "creation_date": Timestamp(date: Date())
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully added!")
            }
        }
    }


    
    func addUshersRecursively(_ ushers: [[String]]) {
        // Base case: If no more users, end recursion
        guard !ushers.isEmpty else { return }
        
        // Extract the first user's data
        let currentUser = ushers[0]
        
        // Ensure the currentUser has three components (first, last, phone)
        guard currentUser.count == 3 else {
            print("Invalid user data format.")
            return
        }
    }
    func addUshersRecursivelyWithDelay(_ ushers: [[String]], delaySeconds: TimeInterval) {
            // Base case: If no more ushers, end recursion
            guard !ushers.isEmpty else { return }

            // Extract the first user's data
            let currentUsher = ushers[0]

            // Ensure the current user has three components (first, last, phone)
            guard currentUsher.count == 3 else {
                print("Invalid user data format.")
                return
            }

            // Add the current user
            addUsher1(userFirst: currentUsher[0], userLast: currentUsher[1], userPh: currentUsher[2])

            // Recursive call after delay for the remaining users
            let remainingUshers = Array(ushers.dropFirst())
            DispatchQueue.global().asyncAfter(deadline: .now() + delaySeconds) {
                addUshersRecursivelyWithDelay(remainingUshers, delaySeconds: delaySeconds)
            }

        
        // Add the current user
        addUsher1(userFirst: currentUsher[0], userLast: currentUsher[1], userPh: currentUsher[2])

        // Recursive call for the remaining users
//        let remainingUsers = Array(users.dropFirst())
        addUshersRecursively(remainingUshers)
    }
// worked correctly Jun30. 11 ushers added.
    func addUshersWithNoDelay(_ ushers: [[String]]) {
        for usher in usherList {
            var documentData: [String: Any] = [:]
            let newDocRef = db.collection("ushers").document()
            if usher.count == 3 {
                documentData = [
                    "first": usher[0],
                    "last": usher[1],
                    "phone": usher[2],
                    "creation_date": Timestamp(date: Date()),
                    "id": newDocRef.documentID
                ]
            }

            // Add a new document in collection "users"
            db.collection("ushers").addDocument(data: documentData) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("Document added with ID: \(usher[2])")
                }
            }
            print("Document successfully added with ID: \(newDocRef.documentID)")
        }

        
    }
    
}

#Preview {
    TestConnecView()
}
