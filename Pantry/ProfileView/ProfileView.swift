//
//  ProfileView.swift
//  Pantry
//
//  Created by Shreya Rathi on 3/9/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: PantryListViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var stats: (eatenThisMonth: Int, wastedThisMonth: Int, itemsTrackedThisMonth: Int,
                              eatenAllTime: Int, wastedAllTime: Int, itemsTrackedAllTime: Int) = (0, 0, 0, 0, 0, 0)
    
    @State var allTimeButtonTrue = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(Color("MediumGreen"))
                    .ignoresSafeArea()
                
                MainProfileContent(stats: stats, allTimeButtonTrue: $allTimeButtonTrue)
            }
        }
        .onAppear {
            stats = viewModel.calculateConsumptionStats()
        }
        .onChange(of: viewModel.consumedItems) { _ in
            stats = viewModel.calculateConsumptionStats()
        }
    }
}

struct MainProfileContent: View {
    let stats: (eatenThisMonth: Int, wastedThisMonth: Int, itemsTrackedThisMonth: Int,
                eatenAllTime: Int, wastedAllTime: Int, itemsTrackedAllTime: Int)
    @Binding var allTimeButtonTrue: Bool
    
    var body: some View {
        VStack {
            Text("Profile")
                .fontWeight(.bold)
                .font(.system(size: 17))
                .foregroundStyle(.white)
                .padding()
            
            ConsumptionDiaryCard(stats: stats, allTimeButtonTrue: $allTimeButtonTrue)
            
            SettingsMenu()
        }
    }
}


struct SettingsMenu: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingSignOutConfirmation = false
    @State private var showHelpConfirmation = false
    
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
                .frame(height: 20)
            
            //open Settings View
            NavigationLink {
                SettingsView()
                    .navigationBarBackButtonHidden()
            } label: {
                LineItemView(imageName: "gear", text: "Settings")
            }
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
            
            //pop up to email some supportemail@gmail.com
            //LineItemView(imageName: "questionmark.circle", text: "Help")
            
            Button{
                showHelpConfirmation = true
            }label:{
                LineItemView(imageName: "questionmark.circle", text: "Help")
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
            
            Button {
                showingSignOutConfirmation = true
            } label: {
                LineItemView(imageName: "rectangle.portrait.and.arrow.right", text: "Logout", imageSize: 23)
            }
            
            Spacer()
                .frame(height: 20)
        }
        .padding(.horizontal, 20)
        .alert("Log Out", isPresented: $showingSignOutConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Yes") {
                Task {
                    try? await authViewModel.signOut()
                }
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
        .alert("Need Help?", isPresented: $showHelpConfirmation) {
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Email support_pantry@gmail.com for help.")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(PantryListViewModel())
        .environmentObject(AuthViewModel())
    
}


//
//  LineItemView.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/18/25.
//

import SwiftUI

struct LineItemView: View {
    var imageName: String
    var text: String
    var imageSize: Int = 25
    
    var body: some View {
        HStack {
            Spacer()
                .frame(width: 10)
            Image(systemName: imageName)
                .font(.system(size: CGFloat(imageSize)))
            Spacer()
            
            Text(text)
                .font(.system(size: 20))
            Text("       ")
            Spacer()
        }
        .foregroundStyle(.white)
    }
}



