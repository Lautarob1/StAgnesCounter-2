//
//  ConfirmationDialogView.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 6/22/24.
//

import SwiftUI

struct ConfirmationDialogView2: View {
    var value0: String
    var value1: String
    var value2: String
    var value3: String
    var value4: String
    var onConfirm: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text(value0)
            HStack {
            Text("First Name: ")
            Text(value1)
                .padding(2)
                }
            HStack {
            Text("Last Name: ")
            Text(value2)
                .padding(2)
                }
            HStack {
            Text("Phone ")
            Text(value3)
                .padding(4)
                }
            HStack {
            Text("UsherID ")
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
    ConfirmationDialogView2(value0: "confirm what:", value1: "John", value2: "Doe", value3: "(305) 123 4567", value4: "idxxxxx", onConfirm: {
               print("Confirmed")
           }, onCancel: {
               print("Cancelled")
           })
}
