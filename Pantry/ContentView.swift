//
//  ContentView.swift
//  Pantry
//
//  Created by Shreya Rathi on 3/8/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        Group{
            if viewModel.userSession != nil{
                PantryTabView()
                    .onAppear{
                        print("user logged in")
                    }
                
                    .environmentObject(viewModel)
            } else{
                SignInView()
                    .onAppear{
                        print("user logged out")
                    }
            }
        }
        .onChange(of: viewModel.userSession) { newValue in
                    // You can add additional logic to ensure smooth transition or reload
                    print("User session changed")
                }
    }
}


