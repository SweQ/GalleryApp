//
//  PhotoController.swift
//  SecurityGalleryApp
//
//  Created by alexKoro on 6/27/21.
//

import UIKit

class PhotoController {
    static let shared = PhotoController()
    var photos: [Photo] = []
    var images: [UIImage] = []
    var currentIndex = 0
    
    private init() {
        
    }
    
    func loadPhotos() {
        photos = (UserDefaultsController.shared.getPhotos() as? [Photo]) ?? []
        
        for photo in photos {
            images.append(photo.image)
        }
    }
    
    func savePhotos() {
        UserDefaultsController.shared.saveClass(object: photos, key: .photo)
    }
}
