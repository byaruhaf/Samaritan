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
    let realm = try! Realm() // Openrealm
    
    func savePageVisit(url: String?, pageTitle: String?) {
        let record = WebHistoryRecord()
        record.pageURL = url ?? ""
        record.pageTitle = pageTitle ?? ""
        record.visitDate = Date()
        
        do {
            try realm.write {
                realm.add(record)
            }
            if #available(iOS 14.0, *) {
                Logger.savingRecord.debug("record successfully saved.")
            } else {
                print("record successfully saved.")
            }
        } catch let error {
            if #available(iOS 14.0, *) {
                Logger.savingRecord.error("Failed to save :Error: \(error.localizedDescription)")
            } else {
                print("Failed to save :Error: \(error.localizedDescription)")
            }
        }
    }
    
    @discardableResult
    func removeLastPageAdded() -> WebHistoryRecord? {
        // Get all pages in the realm
        let pages = realm.objects(WebHistoryRecord.self)
        let LastPageAdded = pages.last
        
        do {
            if let LastPageAdded = LastPageAdded {
                try realm.write{
                    realm.delete(LastPageAdded)
                }
                if #available(iOS 14.0, *) {
                    Logger.deletingRecord.debug("record successfully deleted.")
                } else {
                    print("record successfully deleted.")
                }
                return LastPageAdded
            }
        } catch let error {
            if #available(iOS 14.0, *) {
                Logger.deletingRecord.error("Failed to deleted :Error: \(error.localizedDescription)")
            } else {
                print("Failed to deleted :Error: \(error.localizedDescription)")
            }
        }
        return LastPageAdded
    }
    
    func isHistoryEmpty() -> Bool {
        let pages = realm.objects(WebHistoryRecord.self)
        return pages.last == nil
    }
    
}

