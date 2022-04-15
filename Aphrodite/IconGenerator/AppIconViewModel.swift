//
//  AppIconViewModel.swift
//  Aphrodite
//
//  Created by Tyrant on 2022/4/14.
//

import SwiftUI


class AppIconViewModel: ObservableObject {
    
//    let importer = IconRawImageImporter()?
    
    var image: UIImage?
    
    @Published var exporting = false
    
    var imageDidExits: Bool {
        false
    }
    
    func rawImage(_ i: UIImage) {
        image = i
    }
    
    private var viewController: UIViewController? {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController
    }
    
    
    func presentDocumentPickerController(url: URL) {
        let documentPickerVC = UIDocumentPickerViewController(forExporting: [url])
        viewController?.present(documentPickerVC, animated: true)
    }
    
    func export() {
        print(image)
        
        
        
        Task.detached { [weak self] in
            guard let self = self else { return }
            do {
                
                let direct = AppIconDirectory()
                
                let icons = AppleIconsReader().getAll()
                
                let imageTrans = try await ImageToIcon().resizeIcons(from: self.image!, for: icons)
                
                
                direct.deleteExistingTemporaryDirectoryURL()
                
                try await direct.saveIconsToTemporaryDir(icons: icons, images: imageTrans)
                
                let url = try await direct.archiveTemporaryDirectoryToURL()
                
                Task { @MainActor in
                    self.presentDocumentPickerController(url: url)
                }
            }
//            catch let error as NSError {
//                Task { @MainActor in
////                    self.exportingPhase = .failure(error)
//                }
//            }
        }
    }
}
