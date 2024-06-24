//
//  TestUpdateMassView.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 6/4/24.
//

import SwiftUI

import FirebaseFirestore

struct UpdateMassView: View {
    @State private var selectedDate = Date()
    @State private var masses: [String] = []
    @State private var selectedMassIndex: Int = 1
    @ObservedObject var todayMass = TodayMass()
    @ObservedObject var ushers = Ushers()
    let lang: [String] = ["Spanish","English", "Portuguese", "Other"]
    @State private var attendants: Int = 0
    @State private var isValidAttend: Bool = false
    @State private var headUsher: String = ""
    @State private var selectedUsher: String = ""
    @State private var selectedLanguage: String = "English"
    
    private var language: String = ""
    @State private var type: String = ""
    @State private var dateString: String = ""
    @State var mass: String = ""
    let pickerLabel: String = "select mass"


    var body: some View {
        NavigationView {
            Form {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .onChange(of: selectedDate) { _ in
                        fetchDateMasses(date: selectedDate)
                    }
                Section(header: Text("Select Mass")) {
                    Picker(pickerLabel, selection: $mass) {
                        ForEach(TodayMass.shared.dateMasses, id: \.self) { option in
                            Text(option)
                        }
                    }
//                    .pickerStyle(WheelPickerStyle())
                }

                Section(header: Text("Details")) {
                    HStack {
                    TextField("Atendants", value: $attendants,formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .onChange(of: attendants) { newValue in
                                isValidAttend = checkValidAttend(attend: newValue)
                            }
                        HStack {
                                Text(isValidAttend ? "Valid" : "Invalid")
                                    .foregroundColor(isValidAttend ? .green : .red)
                                    .padding()
              
 
                        }
                    }
                    Picker("Usher", selection: $selectedUsher) {
                        ForEach(Ushers.shared.allUshers, id: \.id) { usher in
                            Text("\(usher.first) \(usher.last)").tag(usher.id)
                        }
                    }
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(lang, id: \.self) { language in
                            Text(language).tag(language)
                           }
                    }
                    TextField("type", text: $type)
                }
                
                Button("Update Details") {
                    updateMassDetails()
                }
            }
            .navigationBarTitle("Mass: Add/Update")
        }
        .onAppear {
            fetchDateMasses(date: selectedDate)
        }
    }
    private func checkValidAttend (attend: Int) -> Bool {
        if attend > 0 && attend < 2000 {
            return true
        }
        else {
            return false
        }
    }
//    private func updateMassDetails() {
//        print("updating mass details")
//        masses = TodayMass.shared.todayMasses
//        print("masses.count \(masses.count)")
//        print("selectedMassIndex \(selectedMassIndex)")
//        guard masses.count > selectedMassIndex else { return }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        
//        let selectedMass = masses[selectedMassIndex]
//        print("selec mass \(selectedMass)")
//        let db = Firestore.firestore()
//        db.collection("dailyMass").document("\(dateFormatter.string(from: Date()))-\(selectedMass)").updateData([
//            "attendants": Int(attendants),
//            "headUsher": headUsher,
//            "language": language,
//            "type": type
//        ]) { error in
//            if let error = error {
//                print("Error updating document: \(error)")
//            } else {
//                print("Document successfully updated")
//            }
//        }
//    }
    func updateMassDetails() {
        TodayMass.shared.massAttend = attendants
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateString = dateFormatter.string(from: Date())


        // Here you would include the logic to save the count
        // For example, writing to UserDefaults, a database, or sending to a server
        print("Saving count: \(attendants)")
    }
    
}

//struct TodayMass1 {
//    var time: String
//    var attendants: Int
//    var headUsher: String
//    var language: String
//}

#Preview {
    UpdateMassView()
}
