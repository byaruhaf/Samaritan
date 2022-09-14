//
//  WebViewModel.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 14/09/2022.
//

import Foundation
import RealmSwift

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
        } catch let error {
            print(error)
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
                return LastPageAdded
            }
        } catch let error {
            print(error)
        }
        return LastPageAdded
    }
    
    func isHistoryEmpty() -> Bool {
        let pages = realm.objects(WebHistoryRecord.self)
        return pages.last == nil
    }
    
}

