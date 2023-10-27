//
//  LoginPage.swift
//  FIre Notes
//
//  Created by Samuel Martins on 27/10/23.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct LoginPage: View {
    @EnvironmentObject var authHelper: AuthHelper
    var body: some View {
        VStack {
            Text("Please Login")
            Button {
                authHelper.signIn()
            } label: {
                Text("Login with Google")
            }.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    LoginPage().environmentObject(AuthHelper())
}
