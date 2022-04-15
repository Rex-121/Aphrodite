//
//  AppIconDirectory.swift
//  Aphrodite
//
//  Created by Tyrant on 2022/4/14.
//

import Foundation
import UIKit


struct AppIconDirectory {
    
    
    let coordinator = NSFileCoordinator()
    let fileManager = FileManager.default
    
    
    private var temporaryDirectoryURL: URL {
        fileManager.temporaryDirectory.appendingPathComponent("AppIcons")
    }
    
    
    func deleteExistingTemporaryDirectoryURL() {
        try? fileManager.removeItem(at: temporaryDirectoryURL)
    }
    
    func archiveTemporaryDirectoryToURL() async throws -> URL {
        
        
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<URL, Error>) in
            
            
            self.coordinator.coordinate(readingItemAt: temporaryDirectoryURL, options: [.forUploading], error: nil) { zipURL in
                let destinationURL = self.temporaryDirectoryURL.appendingPathComponent("app_icons.zip")
                do {
                    try self.fileManager.moveItem(at: zipURL, to: destinationURL)
                                        
                    continuation.resume(returning: destinationURL)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func saveIconsToTemporaryDir(icons: AppleBuiltInIcon, images: [IconImage]) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            do {
                try ios(icons: icons, images: images)
                continuation.resume()
            } catch let error as NSError {
                continuation.resume(throwing: error)
            }
        }
    }
    
    private func ios(icons: AppleBuiltInIcon, images: [IconImage]) throws {
        
        let dirURL = self.temporaryDirectoryURL
            .appendingPathComponent("Apple")
            .appendingPathComponent("AppIcon.appiconset")
        try self.fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true)
        
        for icon in images {
            let url = dirURL.appendingPathComponent(icon.builtIn.fileName)
            try icon.imageData.write(to: url)
        }
        
        let encode = JSONEncoder()
        encode.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        let v = try encode.encode(icons)
        
        try v.write(to: dirURL.appendingPathComponent("Contents.json"))
    }
    
    
    enum AndroidIcon: String, CaseIterable {
        case hdpi
        case mdpi
        case xhdpi, xxhdpi, xxxhdpi
    }
    
    
    func android(rawImage: UIImage) async throws {
        let dirURL = self.temporaryDirectoryURL
            .appendingPathComponent("Android")
        
        try self.fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true)
        
        let all = AndroidIcon.allCases
        
        
        let imageTrans = ImageToIcon()
        
        for icon in all {
            let url = dirURL.appendingPathComponent("mipmap-\(icon.rawValue)")
            try self.fileManager.createDirectory(at: url, withIntermediateDirectories: true)
            let data = try await imageTrans.iconResizedData(from: rawImage, appIconSize: icon.iconSize)
            
            let file = url.appendingPathComponent("ic_launcher.png")
            try data.write(to: file)
            
        }
    }
}


extension AppIconDirectory.AndroidIcon {
    
    var iconSize: Double {
        switch self {
        case .hdpi:
            return 72
        case .mdpi:
            return 48
        case .xhdpi:
            return 96
        case .xxhdpi:
            return 144
        case .xxxhdpi:
            return 196
        }
    }
    
}
