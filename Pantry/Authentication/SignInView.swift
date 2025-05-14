//
//  SignInView.swift
//  Pantry
//
//  Created by Shreya Rathi on 3/8/25.
//

import SwiftUI

struct SignInView: View {
    
    
    
    var body: some View {
        NavigationStack {
            ZStack{
                
                Color("MediumGreen")
                    .ignoresSafeArea()
                
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .shadow(color: Color.black.opacity(0.2),radius: 5)
                    .padding(20)
                
                VStack(alignment: .leading){
                    
                    HeaderView(topText: "Welcome to", bottomText: "Pantry")
                    
                    Spacer()
                        .frame(height: 15)
                    
                    Text("Keeping track of your food has never been easier")
                        .font(.custom("Manrope", size: 17))
                   
                    Image("MainFruits")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 400)
                    
                    
                    
                    VStack(alignment: .center,spacing: 20 ){
                        //sign in buttons
                        NavigationLink {
                            SignUpView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            ButtonView(label: "Sign Up", backgroundColor: Color("DarkGreen"), textColor: Color.white)
                        }
                        
                        
                        
                        NavigationLink {
                            LogInView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            ButtonView(label: "Log In", backgroundColor: Color("LightGreen"), textColor: Color.black)
                        }
                        
                        
                    }
                    
                    
                    
                }
                .padding(50)
                
                
                
                
                
                
            }
        }
    }
    
    init(){
        for familyName in UIFont.familyNames {
            print(familyName)
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print("--- \(fontName)")
            }
        }
    }
}


#Preview {
    SignInView()
}


struct ButtonView: View{
    
    //variable for Color and text
    var label: String
    var backgroundColor: Color
    var textColor: Color
    
    var body: some View {
        ZStack{
            Rectangle()
                .frame(height: 40)
                .cornerRadius(20)
                .foregroundStyle(backgroundColor)
                
            Text(label)
                .foregroundStyle(textColor)
                .font(.custom("Manrope", size: 17))
                
                
        }
    }
    
}

struct HeaderView: View{
    var topText: String
    var bottomText: String
    
    var body: some View{
        Text(topText)
            .fontWeight(.semibold)
            .font(.custom("Manrope-ExtraBold", size: 34))
            .foregroundStyle(Color("DarkGreen"))
            
        Text(bottomText)
            .fontWeight(.semibold)
            .font(.custom("Manrope-ExtraBold", size: 34))
            .foregroundStyle(Color("DarkGreen"))
            
    }
    
}
