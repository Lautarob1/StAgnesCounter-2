//
//  TestUpdateMassView.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 6/20/24.
//

import SwiftUI




struct TestUpdateMassView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button("update Mass") {
            let varMass = "2024-01-01 [1] 8:00 AM"
            updateDailyMassFields(docID: varMass, headUsher: "John Doe", attendants: 120)
        }
    }
}

#Preview {
    TestUpdateMassView()
}
