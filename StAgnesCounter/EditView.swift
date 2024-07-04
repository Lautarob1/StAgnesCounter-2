//
//  EditView.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 4/20/24.
//

import SwiftUI

struct admLoginView: View {
    @Binding var isAdmin: Bool
    @Binding var showAdmLogin: Bool
    @State private var password = ""
    let gradient = RadialGradient(
        gradient: Gradient(colors: [Color.white, Color.blue]),
                center: .center,
                startRadius: 20,
                endRadius: 200
            )
    
    var body: some View {
        VStack(spacing: 10) {
            SecureField("Enter Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5)
            
            HStack {
                Button("  OK  ") {
                    authenticate()
                }
                .foregroundColor(.white)
                .padding(15)
                .background(Color.blue)
            .cornerRadius(10)

            Spacer()
            Button("Cancel") {
                showAdmLogin = false
            }
            .foregroundColor(.white)
            .padding(15)
            .background(Color.blue)
            .cornerRadius(10)
        }
            .padding()
        }
        .background(gradient)
        .cornerRadius(15)
        .padding(10)
    }
    
    private func authenticate() {
        if password == "passw2" { // Use secure methods in production
            isAdmin = true
            showAdmLogin = false
        } else {
            // Optionally handle the error, e.g., display an alert
        }
    }
}

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var count: Int
    @State private var inputText: String = ""
    @State private var isAdmin = false
    @State private var showAdmLogin = false
    @State private var showEditMass = false

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                if showAdmLogin {
                    admLoginView(isAdmin: $isAdmin, showAdmLogin: $showAdmLogin)
                        .frame(width: 300, height: 200)
//                                .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 20)
                }
                VStack {
                    Text("Admin")
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .padding(5)
                        .onTapGesture {
                            showAdmLogin = true
                        }
                    if isAdmin {
                        HStack {
                            NavigationLink(
                                destination: UpdateMassView(),
                                isActive: $showEditMass,
                                label: {
                                    Button("Edit Data") {
                                        Task {
                                            showEditMass = true
                                        }
                                    }
                                    .frame(width: 100, height: 25)
                                    .padding()
                                    .background(Color.brown.opacity(0.7))
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold))
                                    .cornerRadius(8)
                                    .clipShape(Capsule())
                                }
                            )
                            NavigationLink(
                                destination: UpdateUshers(),
                                isActive: $showEditMass,
                                label: {
                                    Button("Edit Ushers") {
                                        Task {
                                            showEditMass = true
                                        }
                                    }
                                    .frame(width: 100, height: 25)
                                    .padding()
                                    .background(Color.brown.opacity(0.7))
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold))
                                    .cornerRadius(8)
                                    .clipShape(Capsule())
                                }
                            )
                        }
                    }
                }
                Spacer()
                Text("-------------------")
                Text("Type revised count")
                    .font(.system(size: 24, weight: .bold))
                    .padding(3)
                TextField("", text: $inputText)
                    .keyboardType(.numberPad)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .frame(width: 100, height: 30)
                    .background(.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    

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
