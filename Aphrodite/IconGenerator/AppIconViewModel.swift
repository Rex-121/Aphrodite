//
//  AppIconViewModel.swift
//  Aphrodite
//
//  Created by Tyrant on 2022/4/14.
//

import SwiftUI


class AppIconViewModel: NSObject, ObservableObject {

    
    @Published var exporting = false
    
    @Published var image: UIImage?

    public let providerIdentifier = "public.image"
    
    
    var imageDidExits: Bool {
        image != nil
    }
    
    private var viewController: UIViewController? {
        if #available(macCatalyst 15.0, *) {
            return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController
        } else {
            return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
        }
    }
    
    
    func presentDocumentPickerController(url: URL) {
        let documentPickerVC = UIDocumentPickerViewController(forExporting: [url])
        viewController?.present(documentPickerVC, animated: true)
    }
    
    
    func importImage() {
//        #if targetEnvironment(macCatalyst)
        let documentPickerVC = UIDocumentPickerViewController(forOpeningContentTypes: [.image])
        documentPickerVC.delegate = self
        viewController?.present(documentPickerVC, animated: true)
//        #else
//        self.viewModel.isPresentingImagePicker = true
//        #endif
    }
    
    func deliverImage(_ image: UIImage?) {
        Task { @MainActor in
            self.image = image
        }
    }
    
    func OnDropProviders(_ providers: [NSItemProvider]) -> Bool {
        providers.first?.loadDataRepresentation(forTypeIdentifier: providerIdentifier) { [weak self] (data, error) in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            self?.deliverImage(image)
        }
        return true
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
                
                try await direct.android(rawImage: self.image!)

                
                try await direct.saveIconsToTemporaryDir(icons: icons, images: imageTrans)
                
                let url = try await direct.archiveTemporaryDirectoryToURL()
                
                
                Task { @MainActor in
                    self.presentDocumentPickerController(url: url)
                }
            }
            catch let error as NSError {
                print(error)
                Task { @MainActor in
                    
//                    self.exportingPhase = .failure(error)
                }
            }
        }
    }
}


extension AppIconViewModel: UIDocumentPickerDelegate {
    
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first,
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return
        }
        deliverImage(image)
    }
    
}
