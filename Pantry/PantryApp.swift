//
//  PantryApp.swift
//  Pantry
//
//  Created by Shreya Rathi on 3/8/25.
//

import SwiftUI
import Firebase

@main
struct PantryApp: App {
    
    @StateObject var viewModel = AuthViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            
           ContentView()
                .environmentObject(viewModel)
                .preferredColorScheme(.light)
            //ObjectDetectionView()
        }
    }
}
