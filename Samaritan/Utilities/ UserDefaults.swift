//
//   UserDefaults.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 15/09/2022.
//

import Foundation
import UIKit

/// Struct for saving zoom value using UserDefaults
@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard

    var wrappedValue: Value {
        get {
             container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

extension UserDefaults {
    private enum Keys {
        static let zoom = "pageZoom"
    }
    
    @UserDefault(key: Keys.zoom, defaultValue: 1.0)
    static var pageZoom: CGFloat
}
