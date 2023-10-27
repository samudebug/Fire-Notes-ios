//
//  ContentView.swift
//  FIre Notes
//
//  Created by Samuel Martins on 26/10/23.
//

import SwiftUI
import FirebaseAuth
struct ContentView: View {
    @EnvironmentObject var authHelper: AuthHelper
    var body: some View {
        NavigationView {
            if authHelper.isSignedin {
                NotesList()
            } else {
                LoginPage()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView().environmentObject(NotesHelper()).environmentObject(StorageHelper()).environmentObject(AuthHelper())
}
