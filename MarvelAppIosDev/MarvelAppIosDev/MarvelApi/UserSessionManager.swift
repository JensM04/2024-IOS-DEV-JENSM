//
//  UserSessionManager.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 21/12/2024.
//

import Foundation
import FirebaseAuth

class UserSessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    
    init() {
        self.isLoggedIn = Auth.auth().currentUser != nil
    }
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
            } else {
                self?.isLoggedIn = true
            }
        }
    }
    
    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] _, error in
            if let error = error {
                print("Registration error: \(error.localizedDescription)")
            } else {
                self?.isLoggedIn = true
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isLoggedIn = false
        } catch let error {
            print("Logout error: \(error.localizedDescription)")
        }
    }
}
