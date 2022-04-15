//
//  ImageToIcon.swift
//  Aphrodite
//
//  Created by Tyrant on 2022/4/15.
//

import UIKit
import CoreImage

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
        
        var thumbnail: UIImage?
        if #available(macCatalyst 15.0, *) {
             thumbnail = v(size: size, image: image)//await image.byPreparingThumbnail(ofSize: size)
        } else {
             thumbnail = v(size: size, image: image)
            // Fallback on earlier versions
        }
        guard let thumbnail = thumbnail,
              let data = thumbnail.pngData()
        else {
            throw NSError(domain: "Tyrant", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate thumbnail data"])
        }
        return IconImage(builtIn: appIcon, imageData: data)
    }
    
    
    private func v(size: CGSize, image: UIImage) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        image.draw(in: CGRect.init(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
//        UIGraphics.BeginImageContext(new SizeF(0, 0))
    }
    
    
     func iconResizedData(from image: UIImage, appIconSize: Double) async throws -> Data {

         var thumbnail: UIImage?
         if #available(macCatalyst 15.0, *) {
             thumbnail = v(size: .init(width: appIconSize, height: appIconSize), image: image)//await image.byPreparingThumbnail(ofSize: .init(width: appIconSize, height: appIconSize))
         } else {
              thumbnail = v(size: .init(width: appIconSize, height: appIconSize), image: image)
             // Fallback on earlier versions
         }
         
         guard let thumbnail = thumbnail,
              let data = thumbnail.pngData()
        else {
            throw NSError(domain: "Tyrant", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate thumbnail data"])
        }
        return data
    }
}
