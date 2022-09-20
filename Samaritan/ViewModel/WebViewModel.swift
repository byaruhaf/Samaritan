//
//  WebViewModel.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 14/09/2022.
//

import Foundation
import RealmSwift
import os.log

/// App's View Model for interacting with Realm DB
final class WebViewModel {
    // swiftlint:disable force_try
    let realm = try! Realm() // Openrealm
    var pages: Results<WebHistoryRecord>

    init() {
        // Get all pages in the realm
        self.pages = realm.objects(WebHistoryRecord.self)
    }

    func savePageVisit(url: String?, historyStatus: HistoryStatus) {
        let record = WebHistoryRecord()
        record.pageURL = url ?? ""
        record.historyStatus = historyStatus
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
    
    func isForwardHistoryEmpty() -> Bool {
        let allForward = realm.objects(WebHistoryRecord.self).where {
            $0.historyStatus == .forward
        }
        return allForward.isEmpty
    }
    
    func isBackwardHistoryEmpty() -> Bool {
        let allForward = realm.objects(WebHistoryRecord.self).where {
            $0.historyStatus == .back
        }
        return allForward.isEmpty
    }

    func moveBack() {
        let lastBack = realm.objects(WebHistoryRecord.self).last { $0.historyStatus == .back }
        let current = realm.objects(WebHistoryRecord.self).first { $0.historyStatus == .current }
        try! realm.write {
            lastBack?.historyStatus = .current
            current?.historyStatus = .forward
        }
    }
    
    func moveForward() {
        let current = realm.objects(WebHistoryRecord.self).first { $0.historyStatus == .current }
        let lastForward = realm.objects(WebHistoryRecord.self).first { $0.historyStatus == .forward }
        try! realm.write {
            current?.historyStatus = .back
            lastForward?.historyStatus = .current
        }
    }
    
    func getCurrent() -> String? {
        let current = realm.objects(WebHistoryRecord.self).first { $0.historyStatus == .current }
        if current == nil {
            let favCurrent = realm.objects(WebHistoryRecord.self).first { $0.historyStatus == .none }
            return favCurrent?.pageURL
        }
        return current?.pageURL
    }
    
    func markAllForwardsOld() {
        let allForward = realm.objects(WebHistoryRecord.self).where {
            $0.historyStatus == .forward
        }
        try! realm.write {
            allForward.forEach {
                $0.historyStatus = .old
            }
        }
    }
    
    func makeOld() {
        let all = realm.objects(WebHistoryRecord.self)
        try! realm.write {
            all.forEach {
                $0.historyStatus = .old
            }
        }
    }
}
