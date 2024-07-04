//
//  SaveView.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 4/20/24.
//

import SwiftUI

struct SaveView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var count: Int
    @ObservedObject var todayMass = TodayMass.shared
    @ObservedObject var ushers = Ushers()
    @State var mass: String = ""
    @State var strMass: String = ""
    @State var todayString: String = ""
    let pickerLabel: String = "select mass"
    @State private var usher: String = ""
    @State private var showingConfirmation = false
    @State private var activateSave = false
    let phUsher = Usher(id: "1000000", first: "Select", last: "Usher", phone: "")
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    var calendar = Calendar.current
    let currentDate = Date()
    @State private var selectedUsherID: String = ""
    @State private var ushers4picker: [Usher] = [Usher(id: "1000000", first: "xxxxx", last: "xxxx", phone: "")]
    let confirmTitle = "You are about to update daily mass:"

//    var massAttendance: Int

    var body: some View {
        NavigationView {
            
            VStack(spacing: 20) {
                Text("Select Mass time and Usher and the submission button will appear")
                Text("\(formattedDate(with: "EEEE, MMMM d, yyyy"))")
                
                HStack {
                    Text("Mass time")
                    Picker(pickerLabel, selection: $todayMass.selectedMass) {
                        ForEach(TodayMass.shared.todayMasses, id: \.self) { mass in
                            Text(mass)
                        }
                    }
                }
                
                HStack {
                    Text("Usher ")
                    Picker("Select Usher", selection: $selectedUsherID) {
                        ForEach(Ushers.shared.allUshers, id: \.id) { usher in
                            Text("\(usher.first) \(usher.last)").tag(usher.id)
                        }
                    }
                }
                Text("--------------------------")
                    .font(.headline)
                
                Text("Attendance count: \(count)")
                    .font(.title)
                if mass != "" && mass != "Selected Mass" && count > 0 && selectedUsherID != "" && selectedUsherID != "Selected Usher" {
                    Button("Save Attendance") {
                        print(todayMass)
                        saveCount()
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
 
                }
                if TodayMass.shared.alreadyUpdate {
                Text("Count already uploaded. Use Update if needed")
                }
                if showingConfirmation {
                    var selectedUsherName: String {
                            guard let usher = Ushers.shared.allUshers.first(where: { $0.id == selectedUsherID }) else {
                                return "No Usher Selected"
                            }
                            return "\(usher.first) \(usher.last)"
                        }
                    
                    ConfirmationDialogView (value0: confirmTitle, value1: todayString, value2: todayMass.selectedMass, value3: selectedUsherName, value4: String(count), onConfirm: {
                        print("onConfirm DLG strMass: \(strMass)")
                        updateDailyMassFields2(docID: strMass, headUsher: selectedUsherID, attendants: count){ result in
                            print(result)}
                        print(" here: \(TodayMass.shared.alreadyUpdate)")
//                        removeUsherPlaceholder()
//                            mass = ""
//                            selectedUsherID = ""
                        showingConfirmation = false
                        
                    }, onCancel: {
                        print("onCancel strMass: \(strMass)")
                        mass = ""
                        selectedUsherID = ""
                        showingConfirmation = false
                    })
                 }
            }
                    .navigationTitle("Save count Mass")
                    .navigationBarItems(trailing: Button("Done") {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    .onAppear {
                        Task {
                            if Ushers.shared.allUshers.isEmpty {
                                await Ushers.shared.queryUshers3()
                                DispatchQueue.main.async {
                                    Ushers.shared.allUshers.insert(phUsher, at: 0)
                                    print("usher count after queryUshers3 \(Ushers.shared.allUshers.count)")
                                }
                            } else {
                                if !Ushers.shared.allUshers.contains(where: { $0.id == "1000000" }) {
                                    Ushers.shared.allUshers.insert(phUsher, at: 0)
                                }
                            }
                        }
                        TodayMass.shared.todayMasses.insert("Select Mass", at: 0)                            }
                
                }
                .padding()
            }
        
    func saveCount() {
        TodayMass.shared.massAttend = count
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        todayString = dateFormatter.string(from: Date())
        print("todayString to FB \(todayString)")
        strMass = todayString + " " + todayMass.selectedMass
//        removeUsherPlaceholder()
        
        showingConfirmation = true
        print("In saveCount() strMass: \(strMass)")


        print("Saving count: \(count)")
    }
    
    private func formattedDate(with format: String) -> String {
            // Create a DateFormatter with the provided date format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            
            // Format the current date using the DateFormatter
            return dateFormatter.string(from: Date())
        }
    
    private func removeUsherPlaceholder() {
        Ushers.shared.allUshers.remove(at: 0)
//        if allWorkers.first?.id == "placeholder" {
//            allWorkers.remove(at: 0)
//        }
    }
}

struct UsherPickerView: View {
    @StateObject private var viewModel = UserViewModel()
    @State private var selectedUser: User?

    var body: some View {
        VStack {
            Picker("Select User", selection: $selectedUser) {
                ForEach(viewModel.users) { user in
                    Text("\(user.first) \(user.last)")
                        .tag(user as User?)
                }
            }
            .pickerStyle(WheelPickerStyle())  // Customize this style as needed
            .padding()

            if let selectedUser = selectedUser {
                Text("Selected User: \(selectedUser.first) \(selectedUser.last)")
                    .padding()
            } else {
                Text("No User Selected")
                    .padding()
            }
        }
    }
}


#Preview {
    SaveView(count: .constant(115), mass: "mass", strMass: "2024-01-01 [1] 8:00 AM")
}
