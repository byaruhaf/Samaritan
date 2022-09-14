//
//  ViewController.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 12/09/2022.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var navToolBar: UIToolbar!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        webView.load("https://www.google.com")
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        print("forwardButtonTapped Tapp")
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        print("backButtonTapped Tapp")
    }
    
}


extension ViewController: WKUIDelegate {

    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences

        return WKWebView(frame: webView.frame, configuration: configuration)
    }
}

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
