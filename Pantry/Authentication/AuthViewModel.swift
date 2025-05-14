//
//  AuthViewModel.swift
//  Pantry
//
//  Created by Shreya Rathi on 3/9/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreCombineSwift
import FirebaseFirestore

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init(){
        self.userSession = Auth.auth().currentUser
        
        Task{
            await fetchUser()
        }
    }
    
    func signIn(withEmail email :String, password: String) async throws{
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        }catch{
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func createUser(withEmail email : String, password: String, fullName: String) async throws{
        
        do{
            
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            
            let user = User(id: result.user.uid, fullName: fullName, email: email)
            
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch{
            print("DEBUG: Failed to create user: \(error.localizedDescription)")
            
        }
    }

    func signOut(){
        do{
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        }catch{
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
        
    }
    
    func updateUserProfile(fullName: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            // Update Firestore
            try await Firestore.firestore()
                .collection("users")
                .document(uid)
                .updateData(["fullName": fullName])
            
            // Update local state
            if var currentUser = self.currentUser {
                currentUser.fullName = fullName
                self.currentUser = currentUser
            }
        } catch {
            print("DEBUG: Failed to update profile: \(error.localizedDescription)")
            throw error
        }
    }
    
    func changePassword(currentPassword: String, newPassword: String) async throws {
        guard let user = Auth.auth().currentUser else { return }
        
        do {
            // Reauthenticate user
            let credential = EmailAuthProvider.credential(
                withEmail: user.email ?? "",
                password: currentPassword
            )
            
            try await user.reauthenticate(with: credential)
            
            // Update password
            try await user.updatePassword(to: newPassword)
        } catch {
            print("DEBUG: Failed to change password: \(error.localizedDescription)")
            throw error
        }
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else { return }
        
        do {
            // Delete user data from Firestore
            try await Firestore.firestore()
                .collection("users")
                .document(user.uid)
                .delete()
            
            // Delete user from Firebase Auth
            try await user.delete()
            
            // Update local state
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to delete account: \(error.localizedDescription)")
            throw error
        }
    }
    
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
        
        print("DEBUG: Current user is \(self.currentUser)")
        
    }
    
    func sendPasswordResetEmail(to email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print("DEBUG: Failed to send password reset email: \(error.localizedDescription)")
            throw error
        }
    }
    
    
    
    
}

