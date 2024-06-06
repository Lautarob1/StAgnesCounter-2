//
//  CounterDataModels.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 4/21/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class DataManager: ObservableObject {
    static let shared = DataManager()
//    @Published var todayMasses: [(num: String, timeMass: String)] = []
    
    @Published var todayMasses: [String] = []
    @Published var allUshers: [String] = []
    @Published var usher: String = ""
    @Published var massAttend: Int = 0
    
    init() {self.only4testinit()}
    func syncDataFromFirebase() {
            // Your code to sync data from Firebase
            // For example:
            let db = Firestore.firestore()
            let todayEventRef = db.collection("events").document("today")
            todayEventRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let num = document.get("num") as? String,
                       let time = document.get("time") as? String {
                        self.todayMasses = [String(num) + String(time)]
                    }
                } else {
                    print("Document does not exist")
                }
            }
            
            let allManagersRef = db.collection("managers")
            allManagersRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        let manager = document.get("name") as? String ?? ""
                        self.allUshers.append(manager)
                    }
                }
            }
        }

    func only4testinit () {
//        self.todayMasses = [(num: "1", timeMass: "8:30 AM"), (num: "2", timeMass: "10:00 AM"),(num: "3", timeMass: "11:30 AM"), (num: "4", timeMass: "1:00 PM"), (num: "5", timeMass: "7:00 PM")]
        self.todayMasses = ["1 - 8:30 AM", "2 - 10:00 AM", "3 - 11:30 AM", "4 - 1:00 PM", "5 - 7:00 PM"]
        self.allUshers = ["Soraya", "Amelita", "Joaquin", "Jose Felix", "Gonzalo", "Reinaldo"]
        
    }
    
}

struct angesMass {
    var date: Date
    var time: String
    var attendees: Int = 0
    var usher: String = ""

    var dictionary: [String: Any] {
        return [
            "date": date,
            "time": time,
            "attendees": attendees,
            "Usher": usher
        ]
    }
}

