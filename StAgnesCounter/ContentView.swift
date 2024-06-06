//
//  ContentView.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 4/20/24.
//

import SwiftUI


struct ContentView: View {
    @State private var counterOn = true
    @State private var showingEdit = false
    @State private var showingSave = false
    @State private var showingEditMass = false
    @State private var massAttendance: Int = 0
    
    
    var body: some View {
        
        NavigationView {
        ZStack {
            Image("MainPagefull")
                .resizable()
            //                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            VStack {
                VStack {
                    Text("St.Agnes Counter")
                        .font(.system(size: 30, weight: .medium, design: .rounded))
                        .padding(.horizontal)
//                    Spacer()
                    Toggle("Activate", isOn: $counterOn)
                        .font(.system(size: 18))
                        .frame(width: 140)
                    
                }
                .toggleStyle(SwitchToggleStyle(tint: .white))
                .foregroundColor(.white)
                Spacer()
                if counterOn {
                    Spacer()
                    
                        HStack(spacing: 20) {
                            NavigationLink(
                                destination: SaveView(count: $massAttendance, mass: "mass"),
                                isActive: $showingSave,
                                label: {
                                    Button("Save") {
                                        DataManager.shared.only4testinit()
                                        showingSave = true
                                    }
                                    .frame(width: 100, height: 30)
                                    .padding()
                                    .background(Color.brown.opacity(0.7))
                                    .foregroundColor(.white)
                                    .font(.system(size: 36, weight: .bold))
                                    .cornerRadius(8)
                                    .clipShape(Capsule())
                                }
                            )
                            
                            NavigationLink(
                                destination: EditView(count: $massAttendance),
                                isActive: $showingEdit,
                                label: {
                                    Button("Edit") {
                                        showingEdit = true
                                    }
                                    .frame(width: 50, height: 30)
                                    .padding()
                                    .background(Color.brown.opacity(0.7))
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .bold))
                                    .cornerRadius(8)
                                    .clipShape(Capsule())
                                }
                            )
                        }
                        .padding(.bottom, 20)
                        VStack {
                            Text("Total Count: \(massAttendance)")
                                .font(.system(size: 26, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(width: 230, height: 30)
                                .background(Color.brown.opacity(0.8))
                            
                            
                            HStack(alignment: .bottom, spacing: 20) {
                                Button("+ 1") {
                                    massAttendance += 1
                                }
                                .frame(width: 100, height: 70)
                                .padding()
                                .background(Color.brown.opacity(0.8))
                                .foregroundColor(.white)
                                .font(.system(size: 36, weight: .bold))
                                .cornerRadius(8)
                                
                                Button("+ 2") {
                                    massAttendance += 2
                                }
                                .frame(width: 50, height: 30)
                                .padding()
                                .background(Color.brown.opacity(0.8))
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .bold))
                                .cornerRadius(8)
                            }
                            
                            .padding()
                        }
                    }
                    }
                }
            }
        }
    }


#Preview {
    ContentView()
}
