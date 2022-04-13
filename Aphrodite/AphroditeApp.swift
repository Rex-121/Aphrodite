//
//  AphroditeApp.swift
//  Aphrodite
//
//  Created by Tyrant on 2022/4/13.
//

import SwiftUI

@main
struct AphroditeApp: App {
//    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
#if targetEnvironment(macCatalyst)
            MainView()
                .onAppear {
                    guard let scenes = UIApplication.shared.connectedScenes as? Set<UIWindowScene> else { return }
                    for window in scenes {
                        guard let sizeRestrictions = window.sizeRestrictions else { continue }
                        sizeRestrictions.minimumSize = CGSize(width: 360, height: 600)
                        sizeRestrictions.maximumSize = sizeRestrictions.minimumSize
                    }
                }
#else
            NavigationView {
                ContentView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
#endif
            //            MainView()
            //                .frame(width: 300, height: 600, alignment: .center)
//                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
