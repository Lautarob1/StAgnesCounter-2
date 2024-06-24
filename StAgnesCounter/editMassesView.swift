//
//  testUpdateDailyMassView.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 6/5/24.
//

import SwiftUI

import FirebaseFirestore

struct editMasses: View {
    @State private var selectedDate = Date()
    @State private var masses: [DailyMass] = []
    @State private var addingMassTime: String = ""
    @State private var isValidTime: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .onChange(of: selectedDate) { _ in
                        fetchMasses()
                    }

                Section(header: Text("Masses")) {
                    ForEach(masses.indices, id: \.self) { index in
                        HStack {
                            TextField("Time", text: $masses[index].time)
                            Spacer()
                            Button("Update") {
                                updateMass(index: index)
                            }
                            Button("Delete") {
                                deleteMass(index: index)
                            }
                        }
                    }

                    HStack {
                    TextField("Add Mass Time", text: $addingMassTime)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: addingMassTime) { newValue in
                                isValidTime = checkValidTime(time: newValue)
                            }
                        HStack {
                            if !isValidTime {
                                Text(isValidTime ? "Valid Time" : "Invalid Time")
                                    .foregroundColor(isValidTime ? .green : .red)
                                    .padding()
                            }
                            if isValidTime {
                                Button("Add Mass") {
                                    addMass()
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Edit Masses")
        }
        .onAppear {
            fetchMasses()
        }
    }

    private func fetchMasses() {
        let db = Firestore.firestore()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: selectedDate)
        
        db.collection("dailyMass").whereField("id", isGreaterThanOrEqualTo: "\(dateString)-").whereField("id", isLessThanOrEqualTo: "\(dateString)-z").getDocuments { (querySnapshot, error) in
            if let documents = querySnapshot?.documents {
                self.masses = documents.map { doc -> DailyMass in
                    let data = doc.data()
                    let id = doc.documentID
                    let time = String(id.split(separator: "-").last ?? "")
                    return DailyMass(time: time, attendants: data["attendants"] as? Int ?? 0, headUsher: data["headUsher"] as? String ?? "", language: data["language"] as? String ?? "", type: data["type"] as? String ?? "")
                }
            }
        }
    }
    
    private func checkValidTime(time: String) -> Bool {
           let timePattern = "^(1[0-2]|0?[1-9]):([0-5][0-9]) [AP]M$"
           let timeRegex = try! NSRegularExpression(pattern: timePattern, options: [])
           let range = NSRange(location: 0, length: time.utf16.count)
           return timeRegex.firstMatch(in: time, options: [], range: range) != nil
       }

    private func updateMass(index: Int) {
        let db = Firestore.firestore()
        let mass = masses[index]
        db.collection("dailyMass").document(mass.time).updateData([
            "time": mass.time // Assuming you also adjust the ID if time changes
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }

    private func addMass() {
        let db = Firestore.firestore()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: selectedDate)
        let newMassId = "\(dateString)-\(addingMassTime)"

        db.collection("dailyMass").document(newMassId).setData([
            "time": addingMassTime,
            "attendants": 0,
            "headUsher": "",
            "language": "",
            "type": ""
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Mass added successfully")
                fetchMasses()
            }
        }
    }

    private func deleteMass(index: Int) {
        let db = Firestore.firestore()
        let massTime = masses[index].time

        db.collection("dailyMass").document(massTime).delete() { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed")
                masses.remove(at: index)
            }
        }
    }
}

struct DailyMass {
    var time: String
    var attendants: Int
    var headUsher: String
    var language: String
    var type: String

    init(time: String, attendants: Int, headUsher: String, language: String, type: String) {
        self.time = time
        self.attendants = attendants
        self.headUsher = headUsher
        self.language = language
        self.type = type
    }
}

#Preview {
    editMasses()
}
