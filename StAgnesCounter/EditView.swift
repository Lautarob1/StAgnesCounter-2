//
//  EditView.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 4/20/24.
//

import SwiftUI

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var count: Int
    @State private var inputText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Text("Type revised count")
                    .font(.system(size: 24, weight: .bold))
                    .padding()
                TextField("", text: $inputText)
                    .keyboardType(.numberPad)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .frame(width: 100, height: 30)
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .padding(.horizontal, 20)
                    .padding(.vertical, 25)
                    

                Button("Update Count") {
                    if let newCount = Int(inputText) {
                        count = newCount
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            .navigationTitle("Edit Count")
            .navigationBarItems(trailing: Button("Done") {
                self.presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                inputText = "\(count)"  // Initialize the TextField with the current count
            }
        }
    }
}


#Preview {
    EditView(count: .constant(10))
}
