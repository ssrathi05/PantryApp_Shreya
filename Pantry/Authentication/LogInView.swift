//
//  LogInView.swift
//  Pantry
//
//  Created by Shreya Rathi on 3/8/25.
//

import SwiftUI
import FirebaseAuth


struct LogInView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showingForgotPassword = false
    @State private var showingResetNotification = false
    @State private var notificationMessage = ""
    @State private var showingLoginError = false
    @State private var loginErrorMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("MediumGreen")
                    .ignoresSafeArea()
                
                Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(50)
                    .shadow(color: Color.black.opacity(0.2), radius: 5)
                    .padding(20)
                    .frame(height: 530)
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
                
                
                VStack(alignment: .leading) {
                    HeaderView(topText: "Welcome", bottomText: "back")
                    
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
                    
                    TextFieldView(binding: $email, title: "EMAIL", placeholder: "Enter email here")
                    Spacer()
                        .frame(height: 20)
                    TextFieldView(binding: $password, title: "PASSWORD", placeholder: "Enter password here", isSecure: true)
                    
                    HStack{
                        Spacer()
                        
                        Button {
                            showingForgotPassword = true
                        } label: {
                            Text("Forgot password?")
                                .font(.system(size: 15))
                                .padding(3)
                                .foregroundColor(Color("DarkGreen"))
                        }
                    }
                    
                    Spacer()
                        .frame(height: 24)
                
                    
                    
                    VStack(alignment: .center, spacing: 15) {
                        Button {
                            Task {
                                do {
                                    try await viewModel.signIn(withEmail: email, password: password)
                                } catch let error as NSError {
                                    switch error.code {
                                    case AuthErrorCode.wrongPassword.rawValue:
                                        loginErrorMessage = "Incorrect password. Please try again."
                                    case AuthErrorCode.invalidEmail.rawValue:
                                        loginErrorMessage = "Invalid email address. Please check your email."
                                    case AuthErrorCode.userNotFound.rawValue:
                                        loginErrorMessage = "No account found with this email. Please sign up."
                                    default:
                                        loginErrorMessage = "Login failed. Please try again."
                                    }
                                    showingLoginError = true
                                }
                            }
                        } label: {
                            ButtonView(label: "Sign In", backgroundColor: Color("DarkGreen"), textColor: Color.white)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 25)
                    
                    HStack(alignment: .center) {
                        Spacer()
                        NavigationLink{
                            SignUpView()
                                .navigationBarBackButtonHidden()
                        }label:{
                            Text("Don't have an account?")
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .frame(width: 260.0)
                                .font(.system(size: 15, design: .rounded))
                                .foregroundStyle(.black)
                            Spacer()
                        }
                       
                        Spacer()
                    }
                }
                .padding(52)
            }
        }
        .sheet(isPresented: $showingForgotPassword) {
            VStack {
                HStack {
                    Button {
                        showingForgotPassword = false
                    } label: {
                        Image(systemName: "xmark")
                            .padding(.leading, 25)
                            .foregroundStyle(.black)
                    }
                    
                    Spacer()
                }
                
                Spacer()
                    .frame(height: 7)
                
                VStack(spacing: 10) {
                    Text("Reset Password")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color("DarkGreen"))
                    
                    Text("Enter your email to receive a password reset link")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button {
                        Task {
                            do {
                                try await viewModel.sendPasswordResetEmail(to: email)
                                notificationMessage = "Password reset email sent to \(email)"
                                showingResetNotification = true
                                showingForgotPassword = false
                            } catch {
                                notificationMessage = "Failed to send reset email: \(error.localizedDescription)"
                                showingResetNotification = true
                            }
                        }
                    } label: {
                        ButtonView(label: "Send Reset Link", backgroundColor: Color("DarkGreen"), textColor: .white)
                            .padding()
                    }
                }
                .padding()
            }
            .presentationDetents([.fraction(0.43)])
            .presentationCornerRadius(45)
        }
        .alert("Password Reset", isPresented: $showingResetNotification) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(notificationMessage)
        }
        .alert("Login Error", isPresented: $showingLoginError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(loginErrorMessage)
        }
    }
}

#Preview {
    LogInView()
}
