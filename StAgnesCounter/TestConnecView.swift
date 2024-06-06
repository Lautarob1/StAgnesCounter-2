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
    let userList = [
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
//            addUsersRecursivelyWithDelay(userList, delaySeconds: 2)
          
        }
    }
    
    func addUser(userFirst: String, userLast: String) {
        // Get a reference to the Firestore database
        let db = Firestore.firestore()
        
        // Create a new document in the "User" collection
        db.collection("User").addDocument(data: [
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

    func addUser1(userFirst: String, userLast: String, userPh: String) {
        // Get a reference to the Firestore database
        let db = Firestore.firestore()
        
        // Create a reference to a new document in the "User" collection
        let newDocRef = db.collection("ushers").document()
        
        // Set up the data to be written, including a placeholder for the ID
        let data: [String: Any] = [
            "u_first": userFirst,
            "u_last": userLast,
            "u_phone": userPh,
            "creation_date": Timestamp(date: Date()),
            "id": newDocRef.documentID // Using the document's ID directly
        ]
        // Write data to Firestore
        newDocRef.setData(data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully added with ID: \(newDocRef.documentID)")
            }
        }
    }
    
    func addUsersRecursively(_ users: [[String]]) {
        // Base case: If no more users, end recursion
        guard !users.isEmpty else { return }
        
        // Extract the first user's data
        let currentUser = users[0]
        
        // Ensure the currentUser has three components (first, last, phone)
        guard currentUser.count == 3 else {
            print("Invalid user data format.")
            return
        }
    }
    func addUsersRecursivelyWithDelay(_ users: [[String]], delaySeconds: TimeInterval) {
            // Base case: If no more users, end recursion
            guard !users.isEmpty else { return }

            // Extract the first user's data
            let currentUser = users[0]

            // Ensure the current user has three components (first, last, phone)
            guard currentUser.count == 3 else {
                print("Invalid user data format.")
                return
            }

            // Add the current user
            addUser1(userFirst: currentUser[0], userLast: currentUser[1], userPh: currentUser[2])

            // Recursive call after delay for the remaining users
            let remainingUsers = Array(users.dropFirst())
            DispatchQueue.global().asyncAfter(deadline: .now() + delaySeconds) {
                addUsersRecursivelyWithDelay(remainingUsers, delaySeconds: delaySeconds)
            }

        
        // Add the current user
        addUser1(userFirst: currentUser[0], userLast: currentUser[1], userPh: currentUser[2])

        // Recursive call for the remaining users
//        let remainingUsers = Array(users.dropFirst())
        addUsersRecursively(remainingUsers)
    }

    
    
}

#Preview {
    TestConnecView()
}
