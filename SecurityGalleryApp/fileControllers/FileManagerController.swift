//
//  FileManagerController.swift
//  SecurityGalleryApp
//
//  Created by alexKoro on 6/22/21.
//

import UIKit

class FileManagerController {
    static let shared = FileManagerController()
    
    private let fileManager = FileManager.default
    private lazy var libraryDirectory = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)[0]
    
    private init() {

    }
    
    private func createDirectory(name: FileManagerDirectoryKey) {
        if fileManager.fileExists(atPath: name.rawValue) == false {
            let directoryURL = libraryDirectory.appendingPathComponent(name.rawValue)
            
            do {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func uploadData(data: Data, to: FileManagerDirectoryKey, fileName: String) {
        switch to {
        case .photo:
            let photosDirectory = libraryDirectory.appendingPathComponent(to.rawValue)
            
            if fileManager.fileExists(atPath: photosDirectory.path) == false {
                createDirectory(name: to)
            }
            let filePath = photosDirectory.appendingPathComponent(fileName)
            
            fileManager.createFile(atPath: filePath.path, contents: data, attributes: nil)
            print("\(fileName) be saved.")
        default:
            break
        }
    }
    
    func uploadImage(_ image: UIImage, name: String) {
        let data = image.pngData()
        guard let imgData = data else {
            print("Upload image error.")
            return
        }
        self.uploadData(data: imgData, to: .photo, fileName: name)
    }
    
    func downloadData(name: String, directory: FileManagerDirectoryKey) -> Data? {
        switch directory {
        case .photo:
            let photosDirectory = libraryDirectory.appendingPathComponent(directory.rawValue)
            let filePath = photosDirectory.appendingPathComponent(name).path
            
            guard fileManager.fileExists(atPath: filePath) else {
                print("DownloadData error.")
                return nil
            }
            
            let data = fileManager.contents(atPath: filePath)
            
            return data
        default:
            break
        }
    }
    
    func clearDirectory(_ directory: FileManagerDirectoryKey) {
        switch  directory {
        case .photo:
            do {
                try fileManager.removeItem(at: libraryDirectory.appendingPathComponent(directory.rawValue))
            } catch {
                print("Clear directory error.")
            }
        default:
            break
        }
    }
    
    func downloadImage(name: String) -> UIImage? {
        guard let data = self.downloadData(name: name, directory: .photo) else {
            return nil
        }
        
        let image = UIImage(data: data)
        return image
    }
}
