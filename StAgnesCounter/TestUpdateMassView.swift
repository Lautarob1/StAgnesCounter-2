//
//  TestUpdateMassView.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 6/4/24.
//

import SwiftUI

import FirebaseFirestore

struct TestUpdateMassView: View {
    @State private var masses: [TodayMass] = []
    @State private var selectedMassIndex: Int = 0
    @State private var attendants: String = ""
    @State private var headUsher: String = ""
    @State private var language: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Mass")) {
                    Picker("Mass Times", selection: $selectedMassIndex) {
                        ForEach(0..<masses.count, id: \.self) { index in
                            Text(self.masses[index].time).tag(index)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                
                Section(header: Text("Details")) {
                    TextField("Attendants", text: $attendants)
                    TextField("Head Usher", text: $headUsher)
                    TextField("Language", text: $language)
                }
                
                Button("Update Details") {
                    updateMassDetails()
                }
            }
            .navigationBarTitle("Mass Details")
        }
        .onAppear {
            fetchTodaysMasses()
        }
    }
    
    private func fetchTodaysMasses() {
        let db = Firestore.firestore()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayDateString = dateFormatter.string(from: Date())
        
        db.collection("dailyMass").whereField("id", isGreaterThanOrEqualTo: "\(todayDateString)-").whereField("id", isLessThanOrEqualTo: "\(todayDateString)-z").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            if let documents = querySnapshot?.documents {
                self.masses = documents.map { doc -> TodayMass in
                    let data = doc.data()
                    let id = doc.documentID
                    let time = String(id.split(separator: "-").last ?? "")
                    return TodayMass(time: time, attendants: data["attendants"] as? Int ?? 0, headUsher: data["headUsher"] as? String ?? "", language: data["language"] as? String ?? "")
                }
            }
        }
    }
    
    private func updateMassDetails() {
        guard masses.count > selectedMassIndex else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let selectedMass = masses[selectedMassIndex]
        let db = Firestore.firestore()
        db.collection("dailyMass").document("\(dateFormatter.string(from: Date()))-\(selectedMass.time)").updateData([
            "attendants": Int(attendants) ?? 0,
            "headUsher": headUsher,
            "language": language
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}

struct TodayMass {
    var time: String
    var attendants: Int
    var headUsher: String
    var language: String
}

#Preview {
    TestUpdateMassView()
}
