//
//  IconRawImageImporter.swift
//  Aphrodite
//
//  Created by Tyrant on 2022/4/13.
//

import SwiftUI

class IconRawImageImporter: NSObject, ObservableObject {
    
    @Published var image: UIImage?

    public let providerIdentifier = "public.image"
    
    
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
}



extension IconRawImageImporter: UIDocumentPickerDelegate {
    
    private var viewController: UIViewController? {
        if #available(macCatalyst 15.0, *) {
            return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController
        } else {
            return (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first,
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return
        }
        deliverImage(image)
    }
    
}
