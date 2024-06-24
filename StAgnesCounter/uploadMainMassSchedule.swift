//
//  uploadMainMassSchedule.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 6/4/24.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import Foundation

func populateMassSchedule() {
    let db = Firestore.firestore()
    let calendar = Calendar.current
    let today = Date()
    let year = calendar.component(.year, from: today)
    
    // Create a DateComponents instance for each day of the year
    for day in 1...365 { // Simplified to 365 days for clarity
        var dateComponents = DateComponents(year: year, day: day)
        dateComponents.calendar = calendar
        // Set up date formatter for the document ID
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = calendar.date(from: dateComponents) {
            let weekday = calendar.component(.weekday, from: date)
            let month = calendar.component(.month, from: date)
            let adjustedWeekday = weekday == 1 ? 7 : weekday - 1
            let dayMasses = decideMassSchedule(weekday: adjustedWeekday, month: month)
            let formattedDate = dateFormatter.string(from: date)
            var massNumber = 1
            var languaje = ""
            for mass in dayMasses {
                let massOrder = " [" + String(massNumber) + "] "
                let massDocument = db.collection("dailyMass").document("\(formattedDate)\(massOrder + mass.time)")
                if mass.time.contains("PM") {
                    languaje = "Spanish"
                }
                else {
                    languaje = "English"
                }
                massDocument.setData([
                    "id": mass.time,
                    "attendants": 0,
                    "headUsher": "",
                    "type": "Regular Mass",
                    "language": languaje
                ])
                massNumber += 1
            }
        }
    }
}

struct Mass {
    var time: String
}

func decideMassSchedule(weekday: Int, month: Int) -> [Mass] {
    let isSummer = (month >= 5 && month <= 9)
    
    switch weekday {
    case 1...5: // Monday to Friday
        return [Mass(time: "8:00 AM"), Mass(time: "6:00 PM")]
    case 6: // Saturday
        return isSummer ? [Mass(time: "9:00 AM"), Mass(time: "6:00 PM")] : [Mass(time: "8:30 AM"), Mass(time: "6:00 PM")]
    case 7: // Sunday
        return isSummer ? [Mass(time: "9:00 AM"), Mass(time: "11:00 AM"), Mass(time: "1:00 PM"), Mass(time: "7:00 PM")]
                        : [Mass(time: "8:30 AM"), Mass(time: "10:00 AM"), Mass(time: "11:30 AM"), Mass(time: "1:00 PM"), Mass(time: "7:00 PM")]
    default:
        return []
    }
}
