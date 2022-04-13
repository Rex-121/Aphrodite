//
//  MainView.swift
//  Aphrodite
//
//  Created by Tyrant on 2022/4/13.
//

import SwiftUI


struct MainView: View {
    
    @StateObject var importer = IconRawImageImporter()
    
    var body: some View {
        mainView//.frame(width: 360, height: 600, alignment: .center)
    }
    
    @ViewBuilder
    private var mainView: some View {
        VStack(spacing: 24) {
            iconView
        }
        .padding()
    }
    
    private var iconView: some View {
        Button {
            importer.importImage()
        } label: {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .foregroundColor(.gray.opacity(0.5))
                .overlay {
                    
                    if let selectedImage = importer.image {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .cornerRadius(24)
                            .clipped()
                        
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                            Text("Select 1024x1024 icon")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                    }
                    
                }
        }
        .frame(width: 200, height: 200, alignment: .center)
        //        .disabled(viewModel.isExportingInProgress)
        .onDrop(of: [importer.providerIdentifier],
                isTargeted: nil,
                perform: importer.OnDropProviders)
        
    }
    
    @State var selectedImage: UIImage?
    
    
    func handleOnDropProviders(_ providers: [NSItemProvider]) -> Bool {
        providers.first?.loadDataRepresentation(forTypeIdentifier: "public.image") { (data, error) in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            Task { @MainActor in
                self.selectedImage = image
            }
        }
        return true
    }
    
    
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
