//
//  AphroditeApp.swift
//  Aphrodite
//
//  Created by Tyrant on 2022/4/13.
//

import SwiftUI

@main
struct AphroditeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
