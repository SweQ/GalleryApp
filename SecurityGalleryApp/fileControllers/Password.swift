//
//  Password.swift
//  SecurityGalleryApp
//
//  Created by alexKoro on 6/27/21.
//

import UIKit

class Password {
    static let shared = Password()
    var password: String? {
        didSet {
            save()
        }
    }
    
    private init() {
        let data = UserDefaultsController.shared.getString(key: .password)
        
        guard let password = data, password != "" else {
            self.password = nil
            return
        }
        print(password)
        
        self.password = password
    }
    
    func save() {
        guard let password = self.password else { return }
        UserDefaultsController.shared.saveString(string: password, key: .password)
    }
    
    func cleare() {
        UserDefaultsController.shared.clearPassword()
    }
    
    func refresh() {
        let data = UserDefaultsController.shared.getString(key: .password)
        guard let password = data else {
            self.password = nil
            return
        }
        
        self.password = password
    }
}
