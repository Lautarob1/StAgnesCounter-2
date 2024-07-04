//
//  ContentView.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 4/20/24.
//

import SwiftUI

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @Binding var showLogin: Bool
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
                showLogin = false
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
        if password == "passw1" { // Use secure methods in production
            isAuthenticated = true
            showLogin = false
        } else {
            // Optionally handle the error, e.g., display an alert
        }
    }
}


struct ContentView: View {
    @State private var counterOn = false
    @State private var showingEdit = false
    @State private var showingSave = false
    @State private var showingEditMass = false
    @State private var massAttendance: Int = 0
    @State private var isAuthenticated = false
    @State private var showLogin = false
    
    
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
                        if isAuthenticated {
                          
                            VStack {
                                Toggle(isOn: $counterOn) {
                                Text(counterOn ? "Activated" : "Activate")
                                    .foregroundColor(counterOn ? .red : .white)
                                }    .background(counterOn ? Color.white.opacity(0.5) : Color.clear)                            .font(counterOn ? .system(size: 20, weight: .bold) : .system(size: 18))
                                    .frame(width: 160, height: 30)
                                    .cornerRadius(5)
                                .padding(25)
                            }
                            .frame(width: 180, height: 40)
                            .background(counterOn ? Color.white.opacity(0.5) : Color.clear)
                            .cornerRadius(7)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .red))
                    .foregroundColor(.white)
                    
//                    ZStack {
                        if isAuthenticated && !counterOn {
                            // Protected content view
                            Text("Welcome!")
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                                .padding()
                        } else {
                            // Default public content
                            if !counterOn {
                            Text("Please log in to use")
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .padding()
                                .onTapGesture {
                                    showLogin = true
                                }
                        }
                    }
                    Spacer()
                        if showLogin {
                            
                            // Login overlay
                            LoginView(isAuthenticated: $isAuthenticated, showLogin: $showLogin)
                                .frame(width: 300, height: 200)
//                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(radius: 20)
                                .offset(y: -350)
                        }
                    if counterOn {
                            HStack(spacing: 20) {
                                NavigationLink(
                                    destination: SaveView(count: $massAttendance, mass: "mass"),
                                    isActive: $showingSave,
                                    label: {
                                        Button("Save") {
                                        task {
                                                await Ushers.shared.queryUshers3()
                                        }
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
                            }
                                .padding()
                            }
                        }
                    }
                }
            }
        }
  

#Preview {
    ContentView()
}
