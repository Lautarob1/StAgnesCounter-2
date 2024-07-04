//
//  testUpdateDailyMassView.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 6/5/24.
//

import SwiftUI

import FirebaseFirestore




struct UpdateUshers: View {
    @State private var ushers = Ushers()
    @State private var addingUsher: Bool = false
    @State private var modifyingUsher: Bool = false
    @State private var deletingUsher: Bool = false
    @State private var first: String = ""
    @State private var last: String = ""
    @State private var phone: String = ""
    @State private var usherID: String = ""
    @State private var selectedUsherID: String = ""
    @State private var showingConfirmation = false
    let confirmTitleA = "About to Add new usher:"
    let confirmTitleM = "About to modify/delete usher:"
    let phUsher = Usher(id: "1000000", first: "Select", last: "Usher", phone: "")
    
    var body: some View {
        NavigationView {
            VStack {
            Form {
                Section(header: Text("Usher add")) {
                    HStack {
                        Text("First Name")
                        TextField("first", text: $first)
                    }
                    HStack {
                        Text("Last Name")
                        TextField("last", text: $last)
                    }
                    HStack {
                        Text("phone")
                        TextField("phone", text: $phone)
                    }
                    Spacer()
                    Button("add") {
                        showingConfirmation = true
                        addingUsher = true
                    }
                }
            }
                ZStack {
                    Form {
                    Section(header: Text("Modify Usher")) {
                        HStack {
                            Picker("Select Usher", selection: $selectedUsherID) {
                                ForEach(Ushers.shared.allUshers, id: \.id) { usher in
                                    Text("\(usher.first) \(usher.last)").tag(usher.id)
                                }
                            }
                        }
                            
                            HStack {
                                Text("phone")
                                TextField("phone", text: $phone)
                            }
                            Spacer()
                            HStack {
                                Button("Modify") {
                                    modifyUsher(id: usherID)
                                }
                                Spacer()
                                Button("Delete") {
                                    deleteUsher(id: usherID)
                                }
                            }
                        }
                    }
                    if showingConfirmation {
                        if addingUsher {
                            ConfirmationDialogView2 (value0: confirmTitleA, value1: first, value2: last, value3: phone, value4: "", onConfirm: {
                                addUsher1(userFirst: first, userLast: last, userPh: phone)
                                showingConfirmation = false
                                addingUsher = false
                                
                            }, onCancel: {
                                print("onCancel")
                                selectedUsherID = ""
                                showingConfirmation = false
                            })
                        }
                        if modifyingUsher {
                            ConfirmationDialogView2 (value0: confirmTitleM, value1: first, value2: last, value3: phone, value4: selectedUsherID, onConfirm: {
                                modifyUsher(id: selectedUsherID)
                                showingConfirmation = false
                                modifyingUsher = false
                                
                            }, onCancel: {
                                print("onCancel")
                                selectedUsherID = ""
                                showingConfirmation = false
                                modifyingUsher = false
                            })
                        }
                        if deletingUsher {
                            ConfirmationDialogView2 (value0: confirmTitleA, value1: first, value2: last, value3: phone, value4: "", onConfirm: {
                                addUsher1(userFirst: first, userLast: last, userPh: phone)
                                showingConfirmation = false
                                deletingUsher = false
                                
                            }, onCancel: {
                                print("onCancel")
                                selectedUsherID = ""
                                showingConfirmation = false
                            })
                        }
                    }
                } // ZStack close
                    
            }
            .navigationBarTitle("Add/Edit Ushers")
            .onAppear {
                Task {
                    if Ushers.shared.allUshers.isEmpty {
                        await Ushers.shared.queryUshers3()
                        DispatchQueue.main.async {
                            Ushers.shared.allUshers.insert(phUsher, at: 0)
                            print("usher count after queryUshers3 \(Ushers.shared.allUshers.count)")
                        }
                    } else {
                        if !Ushers.shared.allUshers.contains(where: { $0.id == "1000000" }) {
                            Ushers.shared.allUshers.insert(phUsher, at: 0)
                        }
                    }
                }
            }
        }
    }
    
    
    
    private func modifyUsher(id: String) {
        
    }
    
    
    private func deleteUsher(id: String) {
//        let db = Firestore.firestore()
//        let massTime = masses[index].time
//        
//        db.collection("dailyMass").document(massTime).delete() { error in
//            if let error = error {
//                print("Error removing document: \(error)")
//            } else {
//                print("Document successfully removed")
//                masses.remove(at: index)
//            }
//        }
    }
    
}

#Preview {
    UpdateUshers()
}
