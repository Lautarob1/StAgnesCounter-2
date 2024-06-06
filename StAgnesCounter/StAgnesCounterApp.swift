//
//  StAgnesCounterApp.swift
//  StAgnesCounter
//
//  Created by EFI-Admin on 4/20/24.
//

import SwiftUI
import Firebase

@main
struct StAgnesCounterApp: App {
    init() {
        FirebaseApp.configure()
        print("configured Firebase!!")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
