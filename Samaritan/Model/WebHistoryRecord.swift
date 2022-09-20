//
//  WebHistoryRecord.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 14/09/2022.
//

import Foundation
import RealmSwift

enum HistoryStatus: String, PersistableEnum {
    case back
    case current
    case forward
    case none
    case old
}

/// Model of  WebView navigation history stored in Realm DB
class WebHistoryRecord: Object {
    /// Primary Key
    @Persisted(primaryKey: true) var id: ObjectId
    /// URL of site visted
    @Persisted var pageURL = ""
    /// Status of entry in backForwardList
    @Persisted var historyStatus: HistoryStatus = .none
    /// Date when site was visted
    @Persisted var visitDate = Date(timeIntervalSince1970: 1)

    convenience init(pageURL: String) {
        self.init()
        self.pageURL = pageURL
    }
}
