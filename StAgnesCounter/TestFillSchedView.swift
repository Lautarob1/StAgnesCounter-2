//
//  TestFillSchedView.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 6/4/24.
//

import SwiftUI

struct TestFillSchedView: View {
    var body: some View {
        VStack (spacing: 20){
            Button("FillSchedule") {
                populateMassSchedule()
            }
            .frame(width: 120, height: 30)
            Text("use only to fill database")
        }
        .frame(width: 250, height: 200)
    }
}

#Preview {
    TestFillSchedView()
}
