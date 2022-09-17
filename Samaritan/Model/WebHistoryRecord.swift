//
//  WebHistoryRecord.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 14/09/2022.
//

import Foundation
import RealmSwift

/// Model of  WebView navigation history stored in Realm DB
class WebHistoryRecord: Object {
    /// Primary Key
    @Persisted(primaryKey: true) var id: ObjectId
    /// URL of site visted
    @Persisted var pageURL = ""
    /// Date when site was visted
    @Persisted var visitDate = Date(timeIntervalSince1970: 1)

    convenience init(pageURL: String) {
        self.init()
        self.pageURL = pageURL
    }
}
