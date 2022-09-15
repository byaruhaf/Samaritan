//
//   UserDefaults.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 15/09/2022.
//

import Foundation

// Extending UserDefaults to save zoom
extension UserDefaults {
    
    private enum Keys {
        static let zoom = "currentZoom"
    }
    
    // Retriving of saved Zoom
    static func getZoomValue() -> CGFloat? {
        return UserDefaults.standard.double(forKey: Keys.zoom)
    }
    
    // Saving of Zoom
    static func set(currentZoom: CGFloat) {
        UserDefaults.standard.set(currentZoom, forKey: Keys.zoom)
    }
    
}
