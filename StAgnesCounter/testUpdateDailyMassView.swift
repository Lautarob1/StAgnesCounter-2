//
//  testUpdateDailyMassView.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 6/5/24.
//

import SwiftUI

import FirebaseFirestore

struct testUpdateDailyMassView: View {
    @State private var selectedDate = Date()
    @State private var masses: [DailyMass] = []
    @State private var addingMassTime: String = ""

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
                        Button("Add") {
                            addMass()
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
                    return DailyMass(time: time, attendants: data["attendants"] as? Int ?? 0, headUsher: data["headUsher"] as? String ?? "", language: data["language"] as? String ?? "")
                }
            }
        }
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
            "language": ""
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

    init(time: String, attendants: Int, headUsher: String, language: String) {
        self.time = time
        self.attendants = attendants
        self.headUsher = headUsher
        self.language = language
    }
}

#Preview {
    testUpdateDailyMassView()
}
