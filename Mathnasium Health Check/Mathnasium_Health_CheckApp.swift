//
//  Mathnasium_Health_CheckApp.swift
//  Mathnasium Health Check
//
//  Created by Kevin Aguilar on 6/9/21.
//

import SwiftUI

@main
struct Mathnasium_Health_CheckApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        SignIn()
        return true
    }
}
