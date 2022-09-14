//
//  WebHistoryRecord.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 14/09/2022.
//

import Foundation
import RealmSwift

class WebHistoryRecord: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var pageURL = ""
    @Persisted var pageTitle = ""
    @Persisted var visitDate = Date(timeIntervalSince1970: 1)
    
    convenience init(pageURL: String, pageTitle: String) {
        self.init()
        self.pageURL = pageURL
        self.pageTitle = pageTitle
    }
}
