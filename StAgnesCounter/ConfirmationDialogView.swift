//
//  ConfirmationDialogView.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 6/22/24.
//

import SwiftUI

struct ConfirmationDialogView: View {
    var value1: String
    var value2: String
    var value3: String
    var value4: String
    var onConfirm: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("You are about to update daily mass:")
            HStack {
            Text("Date: ")
            Text(value1)
                .padding(2)
                }
            HStack {
            Text("Time: ")
            Text(value2)
                .padding(2)
                }
            HStack {
            Text("Usher: ")
            Text(value3)
                .padding(4)
                }
            HStack {
            Text("Attendance: ")
            Text(value4)
                .padding(4)
                }
            HStack {
                Button("Confirm") {
                    onConfirm()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Cancel") {
                    onCancel()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
        .frame(width: 320, height: 250)
    }
}

#Preview {
    ConfirmationDialogView(value1: "2024-01-01", value2: "[1] 8:00 AM", value3: "John Doe", value4: "150", onConfirm: {
               print("Confirmed")
           }, onCancel: {
               print("Cancelled")
           })
}
