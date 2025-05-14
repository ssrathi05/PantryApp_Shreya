//
//  SettingsView.swift
//  Pantry
//
//  Created by Shreya Rathi on 4/27/25.
//

import SwiftUI
import MessageUI
import WebKit

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingDeleteConfirmation = false
    @State private var showingSignOutConfirmation = false
    @Environment(\.dismiss) var dismiss
    
    @State private var showingChangePassoword = false
    @State private var showingChangeProfile  = false
    @State private var showingMailView = false
    @State private var showingTerms = false
    @State private var showingPrivacy = false
    @State private var showingForgotPassword = false
    @State private var showingPasswordResetNotification = false
    @State private var notificationMessage = ""
    
    private var termsURL: String = "https://ssrathi05.github.io/PantryApp/pantry-terms.html"
    private var privacyURL: String = "https://ssrathi05.github.io/PantryApp/pantry-privacy.html"
    
    
    var body: some View {
        ZStack {
            Color("MediumGreen")
                .ignoresSafeArea()
            
            ScrollView {
                
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .padding(.leading, 25)
                    }
                    Spacer()
                }
                
                VStack(spacing: 20) {
                    // User Profile Section
                    VStack(spacing: 15) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Text(
                                    (authViewModel.currentUser?.fullName.prefix(1) ?? "") +
                                    (authViewModel.currentUser?.fullName.split(separator: " ").last?.prefix(1) ?? "")
                                )
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(Color("DarkGreen"))
                            )
                        
                        Text(authViewModel.currentUser?.fullName ?? "")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(authViewModel.currentUser?.email ?? "")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 5)
                    
                    // Settings Sections
                    VStack(spacing: 20) {
                        // Account Settings
                        SettingsSection(title: "Account Settings") {
                            Button {
                                showingChangeProfile = true
                            } label: {
                                SettingsRow(icon: "person.fill", title: "Edit Profile")
                            }
                            
                            Button {
                                showingChangePassoword = true
                            } label: {
                                SettingsRow(icon: "lock.fill", title: "Change Password")
                            }
                            
                            
                        }
                        
//                        // App Preferences
//                        SettingsSection(title: "App Preferences") {
//                            SettingsRow(icon: "moon.fill", title: "Dark Mode")
//                            SettingsRow(icon: "globe", title: "Language")
//                            SettingsRow(icon: "calendar", title: "Date Format")
//                        }
                        
                        // Help & Support
                        SettingsSection(title: "Help & Support") {
                            Button {
                                showingMailView = true
                            } label: {
                                SettingsRow(icon: "envelope.fill", title: "Contact Support")
                            }
                            
                            Button {
                                showingTerms = true
                            } label: {
                                SettingsRow(icon: "doc.fill", title: "Terms of Service")
                            }
                            
                            Button {
                                showingPrivacy = true
                            } label: {
                                SettingsRow(icon: "hand.raised.fill", title: "Privacy Policy")
                            }
                        }
                        
                        // Danger Zone
                        SettingsSection(title: "") {
                            Button {
                                Task {
                                    showingSignOutConfirmation = true
                                }
                            } label: {
                                SettingsRow(icon: "rectangle.portrait.and.arrow.right", title: "Sign Out", color: .white)
                            }
                            
                            Button {
                                showingDeleteConfirmation = true
                            } label: {
                                SettingsRow(icon: "trash.fill", title: "Delete Account", color: Color("Red"))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .alert("Delete Account", isPresented: $showingDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task {
                    try? await authViewModel.deleteAccount()
                }
            }
        } message: {
            Text("Are you sure you want to delete your account? This action cannot be undone.")
        }
        .alert("Sign Out", isPresented: $showingSignOutConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Yes") {
                Task {
                    try? await authViewModel.signOut()
                }
            }
        } message: {
            Text("Are you sure you want to sign out")
        }
        .sheet(isPresented: $showingChangeProfile) {
            EditProfileView()
                .presentationDetents([.fraction(0.43)])
                .presentationCornerRadius(45)
        }
        .sheet(isPresented: $showingChangePassoword) {
            ChangePasswordView()
                .presentationDetents([.fraction(0.47)])
                .presentationCornerRadius(45)
        }
        .sheet(isPresented: $showingMailView) {
            if MFMailComposeViewController.canSendMail() {
                MailView(
                    to: "support@pantryapp.com",
                    subject: "Pantry App Support",
                    message: "Hello Pantry Support Team,\n\nI need assistance with the following:\n\n"
                )
            } else {
                Text("Please set up an email account in your device settings to contact support.")
                    .padding()
            }
        }
        .sheet(isPresented: $showingTerms) {
            LegalDocumentView(title: "Terms of Service", url: URL(string: termsURL)!)
                .presentationDetents([.large])
                .presentationCornerRadius(45)
        }
        .sheet(isPresented: $showingPrivacy) {
            LegalDocumentView(title: "Privacy Policy", url: URL(string: privacyURL)!)
                .presentationDetents([.large])
                .presentationCornerRadius(45)
                
        }
        
        .alert("Password Reset", isPresented: $showingPasswordResetNotification) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(notificationMessage)
        }
    }
}

struct EditProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var fullName: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            HStack{
                Button{
                    dismiss()
                }label: {
                    Image(systemName: "xmark")
                        .padding(.leading, 25)
                }
                
                Spacer()
            }
            Spacer()
                .frame(height: 15)
           
            
            VStack(alignment: .center, spacing: 10) {
                Text("Update Profile")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color("DarkGreen"))
                
                Text("Enter your new profile name")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                
                TextField("New Name", text: $fullName)
                    .padding(15)
                    .font(.system(size: 17, design: .rounded))
                    .background(Color.clear)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                
                Button {
                    Task {
                        do {
                            try await authViewModel.updateUserProfile(fullName: fullName)
                            dismiss()
                        } catch {
                            alertMessage = "Failed to update profile: \(error.localizedDescription)"
                            showingAlert = true
                        }
                    }
                } label: {
                    ButtonView(label: "Update Profile", backgroundColor: Color("DarkGreen"), textColor: .white)
                        .padding()
                }
            }
            .padding()
        }
        .onAppear {
            fullName = authViewModel.currentUser?.fullName ?? ""
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
}

struct ChangePasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            HStack{
                Button{
                    dismiss()
                }label: {
                    Image(systemName: "xmark")
                        .padding(.leading, 25)
                }
                
                Spacer()
            }
            Spacer()
                .frame(height: 30)
            
            VStack(alignment: .leading, spacing: 20) {
                
                SecureField("Current Password", text: $currentPassword)
                    //.textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(15)
                    .font(.system(size: 17, design: .rounded))
                    .background(Color.clear)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                
                SecureField("New Password", text: $newPassword)
                    .padding(15)
                    .font(.system(size: 17, design: .rounded))
                    .background(Color.clear)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                
                SecureField("Confirm New Password", text: $confirmPassword)
                    .padding(15)
                    .font(.system(size: 17, design: .rounded))
                    .background(Color.clear)
                    .frame(height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 0.5)
                    )
                
                Button {
                    Task {
                        do {
                            if newPassword != confirmPassword {
                                alertMessage = "New passwords do not match"
                                showingAlert = true
                                return
                            }
                            
                            try await authViewModel.changePassword(
                                currentPassword: currentPassword,
                                newPassword: newPassword
                            )
                            dismiss()
                        } catch {
                            alertMessage = "Failed to change password: \(error.localizedDescription)"
                            showingAlert = true
                        }
                    }
                } label: {
                    ButtonView(label: "Change Password", backgroundColor: Color("DarkGreen"), textColor: .white)
                        .padding()
                }
            }
            .padding()
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white.opacity(0.8))
                .padding(.leading)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color.white.opacity(0.1))
            .cornerRadius(15)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    var color: Color = .white
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)
            
            Text(title)
                .foregroundColor(color)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
        .background(Color.white.opacity(0.05))
    }
}

struct MailView: UIViewControllerRepresentable {
    let to: String
    let subject: String
    let message: String
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        mail.setToRecipients([to])
        mail.setSubject(subject)
        mail.setMessageBody(message, isHTML: false)
        mail.mailComposeDelegate = context.coordinator
        return mail
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
}

struct LegalDocumentView: View {
    let title: String
    let url: URL
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack{
                Spacer()
                    .frame(height: 2)
                WebView(url: url)
                    .ignoresSafeArea()
                    .padding( 2)
            }
            
            
            VStack{
                HStack {
    //                Text(title)
    //                    .font(.system(size: 20, weight: .bold))
    //                    .foregroundColor(Color("DarkGreen"))
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding(.trailing)
                    }
                }
                .padding()
                Spacer()
            }
            
            
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

struct ForgotPasswordView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var showingSheet: Bool
    @Binding var showingNotification: Bool
    @Binding var notificationMessage: String
    @State private var email = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    showingSheet = false
                } label: {
                    Image(systemName: "xmark")
                        .padding(.leading, 25)
                }
                
                Spacer()
            }
            
            Spacer()
                .frame(height: 15)
            
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
                            try await authViewModel.sendPasswordResetEmail(to: email)
                            notificationMessage = "Password reset email sent to \(email)"
                            showingNotification = true
                            showingSheet = false
                        } catch {
                            errorMessage = "Failed to send reset email: \(error.localizedDescription)"
                            showingError = true
                        }
                    }
                } label: {
                    ButtonView(label: "Send Reset Link", backgroundColor: Color("DarkGreen"), textColor: .white)
                        .padding()
                }
            }
            .padding()
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    let mockViewModel = AuthViewModel()
    mockViewModel.currentUser = User(id: "123", fullName: "John Doe", email: "john@example.com")
    
    return NavigationStack {
        SettingsView()
            .environmentObject(mockViewModel)
    }
}
