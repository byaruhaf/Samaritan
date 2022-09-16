//
//  AppDelegate.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 12/09/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window:UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

// MARK: - State Restoration

extension AppDelegate {

    // For non-scene-based versions of this app on iOS 13.1 and earlier.
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

    // For non-scene-based versions of this app on iOS 13.1 and earlier.
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    @available(iOS 13.2, *)
    // For non-scene-based versions of this app on iOS 13.2 and later.
    func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    @available(iOS 13.2, *)
    // For non-scene-based versions of this app on iOS 13.2 and later.
    func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
        UIApplication.shared.ignoreSnapshotOnNextApplicationLaunch()
    }
    
//    func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
//        return coder.decodeObject(forKey: "Restoration ID") as? UIViewController
//
//    }
//    func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
//        UIApplication.shared.extendStateRestoration()
//        DispatchQueue.main.async {
//            UIApplication.shared.completeStateRestoration()
//        }
//    }
    
}
