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
    @IBOutlet weak var welcomeButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        webView.load("https://www.google.com")
        webView.allowsBackForwardNavigationGestures = true
        webView.isHidden = true
        navToolBar.isHidden = true
        updateNavButtons()
    }
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        print("forwardButtonTapped Tapp")
        if webView.canGoForward {
            webView.isHidden = false
            welcomeButton.isHidden = true
            webView.goForward()
        } else {
            print("Cant go Forward")
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        print("backButtonTapped Tapp")
        if webView.canGoBack {
            webView.goBack()
        } else {
            print("Cant go Back")
            welcomeButton.isHidden = false
            webView.isHidden = true
            
            if webView.canGoForward {
                navToolBar.isHidden = false
                updateNavButtons()
            } else {
                navToolBar.isHidden = true
                updateNavButtons()
            }
        }
    }
    
    @IBAction func welcomeButtonTapped(_ sender: Any) {
        webView.isHidden = false
        navToolBar.isHidden = false
        welcomeButton.isHidden = true
    }
    
    func updateNavButtons() {
       if webView.canGoForward {
           forwardButton.isEnabled = true
       } else {
           forwardButton.isEnabled = false
       }
       if webView.canGoBack {
           backButton.isEnabled = true
       } else {
           backButton.isEnabled = false
       }
   }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateNavButtons()
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
