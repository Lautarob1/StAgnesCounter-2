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
            let dayMasses = decideMassSchedule(weekday: weekday, month: month)
            let formattedDate = dateFormatter.string(from: date)
            
            for mass in dayMasses {
                let massDocument = db.collection("dailyMass").document("\(formattedDate)-\(mass.time)")
                massDocument.setData([
                    "attendants": 0,
                    "headUsher": "",
                    "language": ""
                ])
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
        return [Mass(time: "8AM"), Mass(time: "6PM")]
    case 6: // Saturday
        return isSummer ? [Mass(time: "9AM")] : [Mass(time: "8:30AM")]
    case 7: // Sunday
        return isSummer ? [Mass(time: "9AM"), Mass(time: "11AM"), Mass(time: "1PM"), Mass(time: "7PM")]
                        : [Mass(time: "8:30AM"), Mass(time: "10AM"), Mass(time: "11:30AM"), Mass(time: "1PM"), Mass(time: "7PM")]
    default:
        return []
    }
}
