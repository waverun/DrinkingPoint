//
//  DrinkingPointApp.swift
//  DrinkingPoint
//
//  Created by shay moreno on 21/01/2024.
//

import SwiftUI

@main
struct DrinkingPointApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
