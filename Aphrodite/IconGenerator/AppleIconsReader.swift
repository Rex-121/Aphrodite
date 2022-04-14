//
//  AppleIconsReader.swift
//  Aphrodite
//
//  Created by Tyrant on 2022/4/14.
//

import Foundation

struct AppleIconsReader {
    
    let fileManager = FileManager.default

    private var temporaryDirectoryURL: URL {
           fileManager.temporaryDirectory.appendingPathComponent("AppIcons")
    }
    
    
    func getAll() -> AppleBuiltInIcon {
        
        let path = Bundle.main.url(forResource: "AppleBuiltInIcons", withExtension: "json")

        let data = try! Data(contentsOf: path!)
        
        return try! JSONDecoder().decode(AppleBuiltInIcon.self, from: data)
    }
    
    
    func vv() {
        
        print(temporaryDirectoryURL.path)
        AppIconPersistence.shared.clearDatabase()
//        AppIconPersistence.shared.container.viewContext.fetch([AppIcon.self])
        AppIconPersistence.shared.container.viewContext.performAndWait {
         
        
        let path = Bundle.main.url(forResource: "AppleBuiltInIcons", withExtension: "json")
        
        let data = try! Data(contentsOf: path!)
        
        let value = try! JSONDecoder().decode(AppleBuiltInIcon.self, from: data)
        
        print(value.images)
        
        value.images.map { image in
            let newItem = AppIcon(context:  AppIconPersistence.shared.container.viewContext)
            newItem.builtIn = true
            newItem.scale = image.scale
            let d = Float(image.size.split(separator: "x").first ?? "0") ?? 0
            newItem.size = d
            newItem.idiom = image.idiom
//            AppIconPersistence.shared.container
        }
        
        do {
            try AppIconPersistence.shared.container.viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
//        value.
        }
    }
    
    
//    func v() async throws {
//            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
//                do {
//
//                    let dirURL = self.temporaryDirectoryURL
////                        .appendingPathComponent(appIconType.folderName)
//                        .appendingPathComponent("AppIcon.appiconset")
//                    try self.fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true)
//                    for icon in icons {
//                        let url = dirURL.appendingPathComponent(icon.filename)
//                        try icon.data?.write(to: url)
//                    }
//
//                    let jsonData = try JSONSerialization.data(withJSONObject: appIconType.json, options: [.prettyPrinted, .sortedKeys])
//                    try jsonData.write(to: dirURL.appendingPathComponent("Contents.json"))
//                    continuation.resume()
//                } catch let error as NSError {
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
    
}



struct AppleBuiltInIcon: Codable {
    
    var info = Info()
    
    let images: [BuiltInIcons]
    
    struct BuiltInIcons: Codable {
        let idiom: String
        let scale: String
        let size: String
    }
    
    struct Info: Codable {
        var author = "xcode"
        var version = 1
    }
    
    
}
