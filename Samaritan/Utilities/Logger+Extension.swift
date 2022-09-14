//
//  Logger+Extension.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 14/09/2022.
//

import os.log
import Foundation

@available(iOS 14.0, *)
extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let savingRecord = Logger(subsystem: subsystem, category: "savingRecord")
    static let deletingRecord = Logger(subsystem: subsystem, category: "deletingRecord")
}
