//
//  CounterDataModels.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 4/21/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class TodayMass: ObservableObject {
    static let shared = TodayMass()
    //    @Published var todayMasses: [(num: String, timeMass: String)] = []
    @Published var selectedMass: String = ""
    @Published var todayMasses: [String] = []
    @Published var dateMasses: [String] = []
    @Published var massDetail: [MassDetail] = []
    @Published var massAttend: Int = 0
    @Published var headUsher: String = ""
    @Published var languaje: String = ""
    @Published var type: String = ""
    @Published var alreadyUpdate: Bool = false
    
    init() {self.dailyMassInit()}
 
    func dailyMassInit() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: Date()) // Formats today's date as "YYYY-MM-DD"
        queryMasses3(for: todayString)
        
    }
   
func queryMasses3(for dateString: String) {
         let massesCollection = db.collection("dailyMass")
         let query = massesCollection
             .whereField(FieldPath.documentID(), isGreaterThanOrEqualTo: dateString)
             .whereField(FieldPath.documentID(), isLessThanOrEqualTo: dateString + "z")

         query.getDocuments { snapshot, error in
             guard let documents = snapshot?.documents else {
                 print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                 return
             }
             
             let masses = documents.map { document -> [String: Any] in
                 var data = document.data()
                 data["documentID"] = document.documentID  // Include the document ID in the data
                 return [document.documentID: data]
             }
//             print(masses)  // Print or return the data
//             print(masses.count)
//             print(masses[0])
             let documentIDs = masses.map { $0.keys.first ?? "Unknown" }
             
//             self.todayMasses = documentIDs
             for eachMass in documentIDs {
                 if let range = eachMass.range(of: "[") {
                     let extractedPart = String(eachMass[range.lowerBound...])
                     self.todayMasses.append(extractedPart)
                 }
                 else {
                     print("The character '[' was not found.")
                 }
             }
             
         }
     }

    
}

class Ushers: ObservableObject {
    static let shared = Ushers()
    @Published var allUshers: [Usher] = []
    
    init() {
        self.ushersInit()
    }
    
    func ushersInit() {
        Task {
            await queryUshers3()
        }
    }
    
    func queryUshers() {
        print("inside func queryUshers in Ushers class")
        let db = Firestore.firestore()
        db.collection("ushers").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            guard let documents = querySnapshot?.documents else { return }
            
            let fetchedUshers = documents.compactMap { document -> Usher? in
            let data = document.data()
                print("data from FB in queryUshers: \(data)")
            guard let first = data["first"] as? String,
                  let last = data["last"] as? String,
                  let phone = data["phone"] as? String
                else {
                    print(data["first"] ?? "first: nothing to print")
                    return nil
                }
                // Use the document ID as the unique identifier
                //                print(Usher(id: document.documentID, first: firstName, last: lastName))
                return Usher(id: document.documentID, first: first, last: last, phone: phone)
            }
//            print("fetched ushers inside queryUshers \(fetchedUshers)")
            DispatchQueue.main.async {
                self.allUshers = fetchedUshers
            }
        }
    }
    
    
    func queryUshers2() {
        print(" in query2 func... ")
        let db = Firestore.firestore()
        db.collection("ushers").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error loading ushers: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
//                print("No documents found")
                return
            }
//            print("Documents count: \(documents.count)")
            self.allUshers = documents.map { doc in
                let data = doc.data()
//                print("data: \(data)")
                return Usher(
                    id: doc.documentID,
                    first: data["first"] as? String ?? "",
                    last: data["last"] as? String ?? "",
                    phone: data["phone"] as? String ?? ""
                )
            }
        }
        print("leaving query2 func... ")
        print("all ushers \(Ushers.shared.allUshers) ")
        
    }
    
    func queryUshers3() async {
        let db = Firestore.firestore()
        do {
            let snapshot = try await db.collection("ushers").getDocuments()
            let ushers = snapshot.documents.map { doc -> Usher in
                let data = doc.data()
                return Usher(
                    id: doc.documentID,
                    first: data["first"] as? String ?? "",
                    last: data["last"] as? String ?? "",
                    phone: data["phone"] as? String ?? ""
                )
            }
            DispatchQueue.main.async {
                self.allUshers = ushers
            }
        } catch {
            print("Error loading ushers: \(error.localizedDescription)")
        }
    }
}

struct Usher: Identifiable, Codable, Hashable {
    var id: String // Use Firestore document ID as the unique identifier
    var first: String
    var last: String
    var phone: String
    
    init(id: String, first: String, last: String, phone: String) {
            self.id = id
            self.first = first
            self.last = last
            self.phone = phone
        }
}

struct MassDetail: Identifiable, Codable, Hashable {
    var id: String
    var massAttend: Int
    var headUsher: String
    var languaje: String
    var type: String
    
    init(id: String, massAttend: Int, headUsher: String, languaje: String, type: String) {
        self.id = id
        self.massAttend = massAttend
        self.headUsher = headUsher
        self.languaje = languaje
        self.type = type
        }
}



func fetchTodaysMasses() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let todayString = dateFormatter.string(from: Date()) // Formats today's date as "YYYY-MM-DD"
    
    queryMasses(for: todayString)
}

func fetchDateMasses(date: Date) {
    print("date received in fetch daily mass: \(date)")
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let dateString = dateFormatter.string(from: date) // Formats today's date as "YYYY-MM-DD"
    print("dateString for query FB: \(dateString)")
    queryMassesxDay(for: dateString)
}

func queryMasses(for dateString: String) {
             let massesCollection = db.collection("dailyMass")
             let query = massesCollection
                 .whereField(FieldPath.documentID(), isGreaterThanOrEqualTo: dateString)
                 .whereField(FieldPath.documentID(), isLessThanOrEqualTo: dateString + "z")

             query.getDocuments { snapshot, error in
                 guard let documents = snapshot?.documents else {
                     print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                     return
                 }
                 
                 let masses = documents.map { document -> [String: Any] in
                     var data = document.data()
                     data["documentID"] = document.documentID  // Include the document ID in the data
                     return [document.documentID: data]
                 }

                 let documentIDs = masses.map { $0.keys.first ?? "Unknown" }
                 

                 for eachMass in documentIDs {
                     if let range = eachMass.range(of: "[") {
                         let extractedPart = String(eachMass[range.lowerBound...])
                         TodayMass.shared.todayMasses.append(extractedPart)
                         print("extractedPart: \(extractedPart)")
                         print("TodayMass.shared.todayMasses: \(TodayMass.shared.todayMasses)")
                         
                     }
                     else {
                         print("The character '[' was not found.")
                     }
                 }
                 
             }
         }


//func fetchDateMasses(date: Date) {
//    print("date received in fetch daily mass: \(date)")
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd"
//    let dateString = dateFormatter.string(from: date) // Formats today's date as "YYYY-MM-DD"
//    print("dateString for query FB: \(dateString)")
//    queryMassesxDay2(for: dateString)
//}



func queryMassesxDay (for dateString: String) {
    //    let testDateString="2024-06-01"
    let testDateString = dateString
    let massesCollection = db.collection("dailyMass")
    let query = massesCollection
        .whereField(FieldPath.documentID(), isGreaterThanOrEqualTo: testDateString)
        .whereField(FieldPath.documentID(), isLessThanOrEqualTo: testDateString + "z")
    
    query.getDocuments { snapshot, error in
        guard let documents = snapshot?.documents else {
            print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        
        let masses = documents.map { document -> [String: Any] in
            var data = document.data()
            data["documentID"] = document.documentID  // Include the document ID in the data
            return [document.documentID: data]
        }
        let documentIDs = masses.map { $0.keys.first ?? "Unknown" }
        print(documentIDs)
        for eachMass in documentIDs {
            if let range = eachMass.range(of: "[") {
                let extractedPart = String(eachMass[range.lowerBound...])
                TodayMass.shared.todayMasses.append(extractedPart)
                print("extractedPart: \(extractedPart)")
                print("TodayMass.shared.todayMasses: \(TodayMass.shared.todayMasses)")
                
            }
            else {
                print("The character '[' was not found.")
            }
        }
    }
}

func queryMassesxDay2 (for dateString: String) {
    //    let testDateString="2024-06-01"
    let testDateString = dateString
    let massesCollection = db.collection("dailyMass")
    let query = massesCollection
        .whereField(FieldPath.documentID(), isGreaterThanOrEqualTo: testDateString)
        .whereField(FieldPath.documentID(), isLessThanOrEqualTo: testDateString + "z")
    
    query.getDocuments { snapshot, error in
        guard let documents = snapshot?.documents else {
            print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
            return
        }
        
        let masses = documents.map { document -> [String: Any] in
            var data = document.data()
            data["documentID"] = document.documentID  // Include the document ID in the data
            return [document.documentID: data]
        }
        let documentIDs = masses.map { $0.keys.first ?? "Unknown" }
        print(documentIDs)
        for eachMass in documentIDs {
            if let range = eachMass.range(of: "[") {
                let extractedPart = String(eachMass[range.lowerBound...])
                TodayMass.shared.todayMasses.append(extractedPart)
                print("extractedPart: \(extractedPart)")
                print("TodayMass.shared.dateMasses: \(TodayMass.shared.dateMasses)")
                
            }
            else {
                print("The character '[' was not found.")
            }
        }
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



func updateDailyMassFields(docID: String, headUsher: String, attendants: Int) {
    // Reference to Firestore

      let db = Firestore.firestore()
      
      // Reference the specific document by ID
      let docRef = db.collection("dailyMass").document(docID)
      // Perform the update on the document
      docRef.updateData([
          "headUsher": headUsher,
          "attendants": attendants
      ]) { err in
          if let err = err {
              print("Error updating document: \(err.localizedDescription)")
          } else {
              print("Document successfully updated with new head usher and attendants.")
          }
      }
}

//let varMass = "2024-01-01 [1] 8:00 AM" // Document ID derived from some other part of your application
//updateDailyMassDocument(docID: varMass, headUsher: "John Doe", attendants: 120)


func updateDailyMassFields2(docID: String, headUsher: String, attendants: Int, completion: @escaping (String) -> Void) {
    // Reference to Firestore
    let db = Firestore.firestore()
    print("updateDailyMassFields2: docID= \(docID)")
    print("updateDailyMassFields2: headU= \(headUsher)")
    print("updateDailyMassFields2: atten= \(attendants)")
    // Reference the specific document by ID
    let docRef = db.collection("dailyMass").document(docID)
    
    // First, get the current data from the document
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            if let currentAttendants = document.get("attendants") as? Int, currentAttendants > 0 {
                // If attendants is greater than 0, return a message and do not update
                TodayMass.shared.alreadyUpdate = true
                print("Already updated: \(TodayMass.shared.alreadyUpdate)")
                completion("Already with data, use update mass screen")
            } else {
                // If attendants is 0 or the field doesn't exist, perform the update
                docRef.updateData([
                    "headUsher": headUsher,
                    "attendants": attendants
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err.localizedDescription)")
                        completion("Error updating document: \(err.localizedDescription)")
                    } else {
                        print("Document successfully updated with new head usher and attendants.")
                        completion("Document successfully updated with new head usher and attendants.")
                    }
                }
            }
        } else if let error = error {
            print("Error getting document: \(error.localizedDescription)")
            completion("Error getting document: \(error.localizedDescription)")
        } else {
            completion("Document does not exist")
        }
    }
}


func addUsher1(userFirst: String, userLast: String, userPh: String) {
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
