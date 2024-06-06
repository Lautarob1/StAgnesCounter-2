//
//  testReadFromFirebaseView.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 5/4/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Foundation

class UserViewModel: ObservableObject {
    @Published var users: [User] = []

    init() {
        fetchUsersFromFirestore()
    }

    func fetchUsersFromFirestore() {
            let db = Firestore.firestore()
            db.collection("ushers").getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }

                guard let documents = querySnapshot?.documents else { return }

                let fetchedUshers = documents.compactMap { document -> User? in
                    let data = document.data()
                    guard let firstName = data["u_first"] as? String,
                          let lastName = data["u_last"] as? String else {
                        return nil
                    }

                    // Use the document ID as the unique identifier
                    return User(id: document.documentID, first: firstName, last: lastName)
                }

                DispatchQueue.main.async {
                    self.users = fetchedUshers
                }
            }
        }
    }


struct User: Identifiable, Codable, Hashable {
    var id: String // Use Firestore document ID as the unique identifier
    var first: String
    var last: String
}



struct UserPickerView: View {
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



import FirebaseFirestore
import SwiftUI

// Define the MassSchedule struct
struct MassSchedule {
    var time: String
}

// Initialize Firestore
let db = Firestore.firestore()

// Define the summer and regular schedules
let summerSchedule: [String: [MassSchedule]] = [
    "Sunday": [
        MassSchedule(time: "9:00 AM"),
        MassSchedule(time: "11:00 AM"),
        MassSchedule(time: "1:00 PM"),
        MassSchedule(time: "7:00 PM")
    ],
    "Monday": [
        MassSchedule(time: "8:00 AM"),
        MassSchedule(time: "6:00 PM")
    ],
    "Tuesday": [
        MassSchedule(time: "8:00 AM"),
        MassSchedule(time: "6:00 PM")
    ],
    "Wednesday": [
        MassSchedule(time: "8:00 AM"),
        MassSchedule(time: "6:00 PM")
    ],
    "Thursday": [
        MassSchedule(time: "8:00 AM"),
        MassSchedule(time: "6:00 PM")
    ],
    "Friday": [
        MassSchedule(time: "8:00 AM"),
        MassSchedule(time: "6:00 PM")
    ],
    "Saturday": [
        MassSchedule(time: "9:00 AM"),
        MassSchedule(time: "5:00 PM")
    ]
]

let regularSchedule: [String: [MassSchedule]] = [
    "Sunday": [
        MassSchedule(time: "8:30 AM"),
        MassSchedule(time: "10:00 AM"),
        MassSchedule(time: "11:30 AM"),
        MassSchedule(time: "1:00 PM"),
        MassSchedule(time: "7:00 PM")
    ],
    "Monday": summerSchedule["Monday"]!,
    "Tuesday": summerSchedule["Tuesday"]!,
    "Wednesday": summerSchedule["Wednesday"]!,
    "Thursday": summerSchedule["Thursday"]!,
    "Friday": summerSchedule["Friday"]!,
    "Saturday": summerSchedule["Saturday"]!
]

func uploadSchedules() {
    // Define date ranges for summer and regular schedules
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let summerStart = dateFormatter.date(from: "2024-05-26")!
    let summerEnd = dateFormatter.date(from: "2024-09-06")!
    let calendar = Calendar.current
    
    // Function to upload schedule to Firestore
    func uploadSchedule(date: Date, schedule: [String: [MassSchedule]]) {
        let dayOfWeek = calendar.component(.weekday, from: date)
        let dayName = calendar.weekdaySymbols[dayOfWeek - 1]
        let daySchedule = schedule[dayName] ?? []
        
        let dateString = dateFormatter.string(from: date)
        let dayCollection = db.collection(dateString)
        
        for mass in daySchedule {
            let massDocument = dayCollection.document(mass.time)
            massDocument.setData([
                "time": mass.time
            ])
        }
    }
    
    // Upload summer schedule
    var currentDate = summerStart
    while currentDate <= summerEnd {
        uploadSchedule(date: currentDate, schedule: summerSchedule)
        currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
    // Upload regular schedule for the rest of the year
    let regularStart = calendar.date(byAdding: .day, value: 1, to: summerEnd)!
    let yearEnd = dateFormatter.date(from: "2024-12-31")!
    currentDate = regularStart
    while currentDate <= yearEnd {
        uploadSchedule(date: currentDate, schedule: regularSchedule)
        currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
    print("Schedules uploaded to Firestore successfully.")
}

// Call the function to upload schedules
//uploadSchedules()

#Preview {
    UserPickerView()
}
