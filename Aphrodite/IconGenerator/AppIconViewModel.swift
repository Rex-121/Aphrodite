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
//                let url = Bundle.main.url(forResource: "AppleBuiltInIcons", withExtension: "json")

//                let url = try await self.iconGeneratorService.generateIconsURL(for: appIconTypes, with: selectedImage)
                
                let direct = AppIconDirectory()
                
                
                await try direct.saveIconsToTemporaryDir(icons: AppleIconsReader().getAll())
                
                let url = try await direct.archiveTemporaryDirectoryToURL()
                
                Task { @MainActor in
                    self.presentDocumentPickerController(url: url)
                }
            } catch let error as NSError {
                Task { @MainActor in
//                    self.exportingPhase = .failure(error)
                }
            }
        }
    }
}
