//
//  DrinkingPointApp.swift
//  DrinkingPoint
//
//  Created by shay moreno on 21/01/2024.
//

import SwiftUI

@main
struct DrinkingPointApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authManager = UserAuthManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authManager)
        }
    }
}
