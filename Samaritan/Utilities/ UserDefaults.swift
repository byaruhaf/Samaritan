//
//   UserDefaults.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 15/09/2022.
//

import Foundation
import UIKit

// Extending UserDefaults to save zoom
extension UserDefaults {
    
    private enum Keys {
        static let zoom = "pageZoom"
    }
    
    // Retriving of saved Zoom
    static func getZoomValue() -> CGFloat {
//        if let val = UserDefaults.standard.double(forKey: Keys.zoom) {
//            return CGFloat(val)
//        }
        return 1.0
    }
    
    // Saving of Zoom
    static func set(currentZoom: CGFloat) {
        UserDefaults.standard.set(currentZoom, forKey: Keys.zoom)
    }
    
}
