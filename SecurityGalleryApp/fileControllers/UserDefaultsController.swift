//
//  UserDefaultsController.swift
//  SecurityGalleryApp
//
//  Created by alexKoro on 6/22/21.
//

import UIKit

class UserDefaultsController {
    static let shared = UserDefaultsController()
    private let userDefaults = UserDefaults.standard
    
    private init() {
        
    }
    
    func clearPhotos(_ key: UserDefaultsKeys) {
        guard key == UserDefaultsKeys.photo else { return }
        saveData(data: Data(), key: key)
    }
    
    func clearPassword() {
        saveString(string: "", key: .password)
    }
    
    func saveData(data: Data, key: UserDefaultsKeys) {
        userDefaults.setValue(data, forKey: key)
    }
    
    func saveString(string: String, key: UserDefaultsKeys) {
        userDefaults.setValue(string, forKey: key)
    }
    
    func getData(key: UserDefaultsKeys) -> Data? {
        return (userDefaults.value(forKey: key) as? Data)
    }
    
    func getString(key: UserDefaultsKeys) -> String? {
        return (userDefaults.value(forKey: key) as? String)
    }
    
    func saveClass(object: Any, key: UserDefaultsKeys) {
        if let photo = object as? Photo {
            let data = try? JSONEncoder.init().encode(photo)
            guard let jsonData = data else { return }
            saveData(data: jsonData, key: key)
        } else if let photos = object as? [Photo] {
            let data = try? JSONEncoder.init().encode(photos)
            guard let jsonData = data else { return }
            saveData(data: jsonData, key: key)
            print("[Photos be saved]")
        }
    }
    
    func getPhotos() -> Any? {
        guard let data = getData(key: .photo) else { return nil}
        let photo = try? JSONDecoder.init().decode([Photo].self, from: data)
        return photo
    }
    
    func getPhoto() -> Any? {
        guard let data = getData(key: .photo) else { return nil}
        let photo = try? JSONDecoder.init().decode(Photo.self, from: data)
        return photo
    }
}
