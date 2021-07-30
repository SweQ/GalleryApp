//
//  UserDefaults+SetGetValues.swift
//  SecurityGalleryApp
//
//  Created by alexKoro on 6/22/21.
//

import Foundation

extension UserDefaults {
    func setValue(_ value: Any?, forKey key: UserDefaultsKeys) {
        self.setValue(value, forKey: key.rawValue)
    }
    
    func value(forKey key: UserDefaultsKeys) -> Any? {
        self.value(forKey: key.rawValue)
    }
}
