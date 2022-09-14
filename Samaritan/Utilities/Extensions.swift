//
//  Extensions.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 14/09/2022.
//

import Foundation
import WebKit

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
