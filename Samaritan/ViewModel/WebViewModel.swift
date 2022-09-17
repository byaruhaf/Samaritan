//
//  WebViewModel.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 14/09/2022.
//

import Foundation
import RealmSwift
import os.log

final class WebViewModel {
    // swiftlint:disable force_try
    let realm = try! Realm() // Openrealm
    var pages: Results<WebHistoryRecord>

    init() {
        // Get all pages in the realm
        self.pages = realm.objects(WebHistoryRecord.self)
    }

    func savePageVisit(url: String?) {
        let record = WebHistoryRecord()
        record.pageURL = url ?? ""
        record.visitDate = Date()
    
        do {
            try realm.write {
                realm.add(record)
            }
            if #available(iOS 14.0, *) {
                Logger.savingRecord.debug("record successfully saved.")
            } else {
                os_log("record successfully saved.", log: OSLog.default, type: .debug)
            }
            // swiftlint:disable untyped_error_in_catch
        } catch let error {
            if #available(iOS 14.0, *) {
                Logger.savingRecord.error("Failed to save :Error: \(error.localizedDescription)")
            } else {
                os_log("Failed to save.....", log: OSLog.default, type: .error)
            }
        }
    }

    @discardableResult
    func removeLastPageAdded() -> WebHistoryRecord? {
        let lastPageAdded = pages.last

        do {
            if let lastPageAdded = lastPageAdded {
                try realm.write {
                    realm.delete(lastPageAdded)
                }
                if #available(iOS 14.0, *) {
                    Logger.deletingRecord.debug("record successfully deleted.")
                } else {
                    os_log("record successfully deleted.", log: OSLog.default, type: .debug)
                }
                return lastPageAdded
            }
        } catch let error {
            if #available(iOS 14.0, *) {
                Logger.deletingRecord.error("Failed to deleted :Error: \(error.localizedDescription)")
            } else {
                os_log("Failed to deleted.....", log: OSLog.default, type: .error)
            }
        }
        return lastPageAdded
    }

    func isHistoryEmpty() -> Bool {
        let pages = realm.objects(WebHistoryRecord.self)
        return pages.isEmpty
    }
}
