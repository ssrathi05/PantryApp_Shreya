
 // PantryTabView.swift
 // Pantry

 // Created by Shreya Rathi on 3/12/25.


import SwiftUI

struct PantryTabView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var pantryViewModel = PantryListViewModel()
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 400, height: 30)
                .cornerRadius(20)
                .foregroundStyle(.white)
                
            
            TabView {
                PantryListView()
                    .tabItem {
                        Label("Pantry List", systemImage: "refrigerator")
                    }
                    
                
                ShoppingListView()
                    .tabItem {
                        Label("Shopping List", systemImage: "cart")
                    }
                    
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                
            }
            
            .background(Color.white.ignoresSafeArea())
            .tint(Color("DarkGreen"))
            .environmentObject(pantryViewModel)
        }
        
        
    }
}

#Preview {
    PantryTabView()
        .environmentObject(AuthViewModel())
    
}


