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
//    let persistenceController = AppIconPersistence.shared
    var body: some Scene {
        
        WindowGroup {
#if targetEnvironment(macCatalyst)
            
//            HStack {
//
//                MainView()
//                    .frame(minWidth: 500, minHeight: 600, alignment: .center)
//                    .onAppear {
//                        guard let scenes = UIApplication.shared.connectedScenes as? Set<UIWindowScene> else { return }
//                        for window in scenes {
//                            guard let sizeRestrictions = window.sizeRestrictions else { continue }
//                            sizeRestrictions.minimumSize = CGSize(width: 1200, height: 600)
//                            sizeRestrictions.maximumSize = sizeRestrictions.minimumSize
//                        }
//                    }.fixedSize()
//
//                Divider().fixedSize()
//
//                    .background(.blue)

            MainView()
//                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            }
#else
            NavigationView {
//               MainView()
            }
            .navigationViewStyle(StackNavigationViewStyle())
#endif
            //            MainView()
            //                .frame(width: 300, height: 600, alignment: .center)
//                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
