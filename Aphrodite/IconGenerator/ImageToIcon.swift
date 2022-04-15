//
//  ImageToIcon.swift
//  Aphrodite
//
//  Created by Tyrant on 2022/4/15.
//

import UIKit

struct ImageToIcon {
    
    func resizeIcons(from image: UIImage, for appIconType: AppleBuiltInIcon) async throws -> [IconImage] {
        let icons = appIconType.images
        return try await withThrowingTaskGroup(of: IconImage.self) { group in
            var results = [IconImage]()
            for icon in icons {
                group.addTask { try await self.iconResizedData(from: image, appIcon: icon) }
            }
            
            for try await iconData in group {
                results.append(iconData)
            }
            
            return results
        }
    }
    
    private func iconResizedData(from image: UIImage, appIcon: AppleBuiltInIcon.BuiltInIcons) async throws -> IconImage {
        let size = appIcon.icon.size
        guard let thumbnail = await image.byPreparingThumbnail(ofSize: size),
              let data = thumbnail.pngData()
        else {
            throw NSError(domain: "Tyrant", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate thumbnail data"])
        }
        return IconImage(builtIn: appIcon, imageData: data)
    }
    
    
     func iconResizedData(from image: UIImage, appIconSize: Double) async throws -> Data {
//        let size = appIcon.icon.size
        guard let thumbnail = await image.byPreparingThumbnail(ofSize: .init(width: appIconSize, height: appIconSize)),
              let data = thumbnail.pngData()
        else {
            throw NSError(domain: "Tyrant", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate thumbnail data"])
        }
        return data
    }
}
