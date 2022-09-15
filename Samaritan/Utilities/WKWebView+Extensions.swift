//
//  Extensions.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 14/09/2022.
//

import Foundation
import WebKit

// MARK: - WebView Extension
extension WKWebView {
    /// Loading url String
    func load(_ urlString: String) {
        guard let url = URL(string: urlString) else { return}
            let request = URLRequest(url: url)
            load(request)
        }
    }
