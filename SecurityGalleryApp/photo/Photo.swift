//
//  Photo.swift
//  SecurityGalleryApp
//
//  Created by alexKoro on 6/22/21.
//

import UIKit

class Photo: Codable {
    var name: String
    var isLike: Bool
    var comment: String
    var orientation: Int
    var image: UIImage {
        get {
            let img = FileManagerController.shared.downloadImage(name: self.name) ?? UIImage(systemName: "doc") ?? UIImage()
            if let cgImge = img.cgImage {
                switch orientation {
                case 1:
                    let image = UIImage(cgImage: cgImge, scale: 1.0, orientation: .down)
                    return image
                case 2:
                    let image = UIImage(cgImage: cgImge, scale: 1.0, orientation: .left)
                    return image
                case 3:
                    let image = UIImage(cgImage: cgImge, scale: 1.0, orientation: .right)
                    return image
                case 0:
                    return img
                    
                default:
                    return img
                }
            
            } else {
                    return img
            }
        }
    }
    
    init(name: String, isLike: Bool, comment: String, image: UIImage, orientation: Int) {
        self.name = name
        self.isLike = isLike
        self.comment = comment
        self.orientation = orientation
        FileManagerController.shared.uploadImage(image, name: name)
    }
    
    
}
