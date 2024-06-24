//
//  ComboBoxView.swift
//  LLimg_sw01
//
//  Created by EFI-Admin on 11/29/23.
//

import SwiftUI

struct ComboBoxView: View {
//    @Binding var todayMasses: [(num: String, timeMass: String)]
//    @Binding var allUshers: [String]
//    @Binding var usher: String
//    @Binding var massAttend: Int
    @State var isComboDisabled: Bool = false
    @State private var usher: String = ""
    @State private var allUshers: [String] = ["Soraya", "Amelita", "Joaquin", "Jose Felix", "Gonzalo", "Reinaldo"]
    let pickerLabel: String
    let toggleLabel: String
    
    var body: some View {
        
        VStack {
//             Left-aligned Toggle in an HStack
            HStack {
//                Toggle(toggleLabel, isOn: $isComboDisabled)
//                    .onChange(of: isComboDisabled) { newValue in comboToggleFunc(isDisabled: newValue)
//                    }
                    Spacer()
                    }

                    .padding([.leading, .trailing])
                HStack {
                    // ComboBox (Picker)
                    Picker(pickerLabel, selection: $usher) {
                        ForEach(allUshers, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle()) // Use MenuPickerStyle for a combo box appearance
                }
            }

            .padding()
            .background(Color.clear)
            
        }
        

    func comboToggleFunc(isDisabled: Bool) {
        usher = "usher name"
        print("Toggle changed to: \(isDisabled)")

}
}


//struct ComboBoxView_Previews: PreviewProvider {
//    @State static var selectedOption = "Usher name" // Static State variable
//    @State static var isComboDisabled = true
//
//    static var previews: some View {
//        let previewdiskDataManager = DataManager.shared
//        ComboBoxView(selectedDskOption: $selectedOption, isComboDisabled: $isComboDisabled, pickerLabel: "Choose Option", toggleLabel: "Ushers")
//            .environmentObject(previewdiskDataManager)
//    }
//}




#Preview {
//    ComboBoxView as! any View
    ComboBoxView(pickerLabel: "Select", toggleLabel: "hola")
}

