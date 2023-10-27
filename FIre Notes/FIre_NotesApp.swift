//
//  FIre_NotesApp.swift
//  FIre Notes
//
//  Created by Samuel Martins on 26/10/23.
//

import SwiftUI
import Firebase
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ app: UIApplication, open url: URL, options optins: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct FIre_NotesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var notesModel = NotesHelper()
    @StateObject private var storageHelper = StorageHelper()
    @StateObject private var authHelper = AuthHelper()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(notesModel).environmentObject(storageHelper).environmentObject(authHelper)
        }
    }
}
