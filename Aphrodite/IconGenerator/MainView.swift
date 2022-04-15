//
//  MainView.swift
//  Aphrodite
//
//  Created by Tyrant on 2022/4/13.
//

import SwiftUI


struct MainView: View {
    
//    @StateObject var importer = IconRawImageImporter()
    
    @StateObject var viewModel = AppIconViewModel()
    
    var body: some View {
        mainView
    }
    
    @ViewBuilder
    private var mainView: some View {
        
        VStack(spacing: 24) {
            iconView
            exportView
        }
        .padding()
    }
    
    private var iconView: some View {
        Button {
            viewModel.importImage()
        } label: {
//            if #available(macCatalyst 15.0, *) {
//                RoundedRectangle(cornerRadius: 24, style: .continuous)
//                    .foregroundColor(.gray.opacity(0.5))
//                    .overlay {
//
//                        if let selectedImage = viewModel.image {
//
//                            Image(uiImage: selectedImage)
//                                .resizable()
//                                .cornerRadius(24)
//                                .clipped()
//
//                        } else {
//                            VStack(spacing: 16) {
//                                Image(systemName: "photo")
//                                    .font(.largeTitle)
//                                Text("Select 1024x1024 icon")
//                                    .font(.caption)
//                            }
//                            .foregroundColor(.white)
//                        }
//
//                    }
//            } else {
                if let selectedImage = viewModel.image {
                    
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
                    .foregroundColor(.blue)
                }
//            }
        }
        .frame(width: 200, height: 200, alignment: .center)
        //        .disabled(viewModel.isExportingInProgress)
        .onDrop(of: [viewModel.providerIdentifier],
                isTargeted: nil,
                perform: viewModel.OnDropProviders)
        
    }
    
    @ViewBuilder
    private var exportView: some View {
//        Divider()
//        VStack {
//            Toggle("iOS", isOn: $viewModel.exporting)
////            Toggle("iPad", isOn: $viewModel.isExportingToiPad)
////            Toggle("Mac", isOn: $viewModel.isExportingToMac)
////            Toggle("Apple Watch", isOn: $viewModel.isExportingToWatch)
//        }
        
        Divider()
        
        Button {
            viewModel.export()
        } label: {
            Text("Export")
        }
//        .buttonStyle(BorderedProminentButtonStyle())
        .disabled(!viewModel.imageDidExits)
        
    }
    
//    @State var selectedImage: UIImage?
    
    
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
