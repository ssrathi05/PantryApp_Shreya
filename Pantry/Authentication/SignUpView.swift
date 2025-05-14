//
//  SignUpView.swift
//  Pantry
//
//  Created by Shreya Rathi on 3/8/25.
//

import SwiftUI


struct SignUpView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var fullName: String = ""
    //enviorment dismiss
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: AuthViewModel
    
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
                    .frame(height: 600)
                
                VStack {
                    Spacer()
                        .frame(height: 50)
                    HStack{
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 22))
                                .foregroundColor(.white)
                        }

                       
                           
                        Spacer()
                            .frame(width: 300)
                    }
                    Spacer()
                }
                .ignoresSafeArea(.all)
                
                Spacer()
                
                
                VStack(alignment: .leading){
                    
                    HeaderView(topText: "Create Your", bottomText: "Account")
                            
//                    HStack{
//                        Spacer()
//                        Text(" ")
//                        Image("Fruits2")
//                            .resizable()
//                            .scaledToFit()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 15,height: 130)
//                        Spacer()
//                    }
                    
                    Spacer()
                        .frame(height: 35)
                    
                    TextFieldView(binding: $fullName, title: "FULL NAME", placeholder: "Enter full name here")
                    Spacer()
                        .frame(height: 15)
                    TextFieldView(binding: $email, title: "EMAIL", placeholder: "Enter email here")
                    Spacer()
                        .frame(height: 15)
                    TextFieldView(binding: $password, title: "PASSWORD", placeholder: "Enter password here", isSecure: true)
                    
                                
                    Spacer()
                        .frame(height:35)
                   
                    
                    
                    VStack(alignment: .center,spacing: 15){
                        //sign in buttons
                         Button {
                           
                             Task{
                                 try await viewModel.createUser(withEmail: email, password: password, fullName: fullName)
                             }
                             
                        } label: {
                            ButtonView(label: "Sign Up", backgroundColor: Color("DarkGreen"), textColor: Color.white)
                        }
                       
                    }
                    
                    Spacer()
                        .frame(height: 25)
                    
                    HStack(alignment: .center){
                        Spacer()
                            
                        Text("By creating an account I agree to the Terms and Conditions and Privacy Policy.")
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .frame(width: 260.0)
                            .font(.system(size: 13, design: .rounded))
                        Spacer()
                        
                    }
                    
                    
                }
                .padding(52)
                
                
                
                
                
                
            }
        }
    }
}

#Preview {
    SignUpView()
}



