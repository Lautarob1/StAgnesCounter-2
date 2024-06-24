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
    @ObservedObject var todayMass = TodayMass()
    @ObservedObject var ushers = Ushers()
    @State var mass: String = ""
    @State var strMass: String = ""
    @State var todayString: String = ""
    let pickerLabel: String = "select mass"
    @State private var usher: String = ""
    @State private var showingConfirmation = false
    @State private var activateSave = false
    
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    var calendar = Calendar.current
    let currentDate = Date()
    @State private var selectedUsher = ""

//    var massAttendance: Int

    var body: some View {
        NavigationView {
            
            VStack(spacing: 20) {
                Text("Select Mass time and Usher and the submission button will appear")
                Text("\(formattedDate(with: "EEEE, MMMM d, yyyy"))")
                
                HStack {
                    Text("Mass time")
                    Picker(pickerLabel, selection: $mass) {
                        ForEach(TodayMass.shared.todayMasses, id: \.self) { option in
                            Text(option)
                        }
                    }
                }
                
                HStack {
                    Text("Usher ")
                    Picker("Usher", selection: $selectedUsher) {
                        ForEach(Ushers.shared.allUshers, id: \.id) { usher in
                            Text("\(usher.first) \(usher.last)").tag(usher.id)
                        }
                    }
                }
                Text("--------------------------")
                    .font(.headline)
                
                Text("Attendance count: \(count)")
                    .font(.title)
                if mass != "" && count > 0 && selectedUsher != "" {
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
                            guard let usher = Ushers.shared.allUshers.first(where: { $0.id == selectedUsher }) else {
                                return "No Usher Selected"
                            }
                            return "\(usher.first) \(usher.last)"
                        }
                    
                    ConfirmationDialogView (value1: todayString, value2: mass, value3: selectedUsherName, value4: String(count), onConfirm: {
                        updateDailyMassFields2(docID: strMass, headUsher: selectedUsher, attendants: count){ result in
                            print(result)}
                        print(" here: \(TodayMass.shared.alreadyUpdate)")
                        showingConfirmation = false
                        
                    }, onCancel: {
                        showingConfirmation = false
                    })
                 }
            }
                    .navigationTitle("Count - Regular Mass")
                    .navigationBarItems(trailing: Button("Done") {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    //        .onAppear {
                    //            print(massAttendance)
                    //        }
                    
                    .padding()
                }
            }
        
    func saveCount() {
        TodayMass.shared.massAttend = count
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        todayString = dateFormatter.string(from: Date())

        
        showingConfirmation = true
        print("StrMass: \(strMass)")

        // Here you would include the logic to save the count
        // For example, writing to UserDefaults, a database, or sending to a server
        print("Saving count: \(count)")
    }
    
    private func formattedDate(with format: String) -> String {
            // Create a DateFormatter with the provided date format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            
            // Format the current date using the DateFormatter
            return dateFormatter.string(from: Date())
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
