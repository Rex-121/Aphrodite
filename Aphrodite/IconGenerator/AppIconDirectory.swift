//
//  AppIconDirectory.swift
//  Aphrodite
//
//  Created by Tyrant on 2022/4/14.
//

import Foundation


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
             
                let dirURL = self.temporaryDirectoryURL
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
                continuation.resume()
            } catch let error as NSError {
                continuation.resume(throwing: error)
            }
        }
    }
}
