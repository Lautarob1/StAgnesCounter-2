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
    @State var todayMasses = ["1 - 8:30 AM", "2 - 10:00 AM", "3 - 11:30 AM", "4 - 1:00 PM", "5 - 7:00 PM"]
    @ObservedObject var dataManager = DataManager()
    @State var mass: String
    @State private var allUshers: [String] = ["Soraya", "Amelita", "Joaquin", "Jose Felix", "Gonzalo", "Reinaldo"]

    let pickerLabel: String = "select mass"
    @State private var usher: String = ""
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    var calendar = Calendar.current
    let currentDate = Date()

//    var massAttendance: Int

    var body: some View {
        NavigationView {
            
            VStack(spacing: 20) {
//                if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
//                    Text("Next date (one day later): \(nextDate)")
//                } else {
//                    Text("Failed to calculate next date.")
//                }
                Text("\(formattedDate(with: "EEEE, MMMM d, yyyy"))")
//                Text("Second Format: \(formattedDate(with: "EEEE MM/dd/yyyy h:mm a"))")
                HStack {
                    Text("Mass time")
                    Picker(pickerLabel, selection: $mass) {
                        ForEach(todayMasses, id: \.self) { option in
                            Text(option)
                        }
                    }
                }
                
                HStack {
                    Text("Usher ")
                    Picker("Usher", selection: $usher) {
                        ForEach(allUshers, id: \.self) { option in
                            Text(option)
                            //                    ComboBoxView(pickerLabel: "select", toggleLabel: "Usher")
                        }
                        
                        
                        Text("Save the count")
                            .font(.headline)
                        
                        Text("head count: \(count)")
                            .font(.title)
                        
                        Button("Save Attendance") {
                            saveCount()
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                    .navigationTitle("Save Count")
                    .navigationBarItems(trailing: Button("Done") {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                    //        .onAppear {
                    //            print(massAttendance)
                    //        }
                    
                    .padding()
                }
            }
        }
    }
    func saveCount() {
        DataManager.shared.massAttend = count
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




#Preview {
    SaveView(count: .constant(12), mass: "mass")
}
