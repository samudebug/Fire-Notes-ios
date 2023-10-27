//
//  AuthHelper.swift
//  FIre Notes
//
//  Created by Samuel Martins on 27/10/23.
//

import Foundation
import Firebase
import GoogleSignIn

class AuthHelper: ObservableObject {
    @Published var isSignedin: Bool = false
    
    init() {
        Auth.auth().addStateDidChangeListener {
            auth, user in
            if user != nil {
                self.isSignedin = true
            } else {
                self.isSignedin = false
            }
        }
    }
    func signIn() {
        guard let clientId = FirebaseApp.app()?.options.clientID else {return}
        let config = GIDConfiguration(clientID: clientId)
        GIDSignIn.sharedInstance.configuration = config
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) {
            [unowned self] user, error in
            guard error == nil else {
                print("error logging in: \(String(describing: error))")
                return;
            }
            guard let user = user?.user, let idToken = user.idToken?.tokenString else {
                print("error logging in: \(String(describing: error))")
                return;
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) {
                result, error in
                guard error == nil else {
                    print("error: \(String(describing: error))")
                    return;
                }
                print("Login done")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error)")
        }
    }
}
