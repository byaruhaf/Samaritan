//
//  ViewController.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 12/09/2022.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let url = URL(string: "https://stil.kurir.rs/moda/157971/ovo-su-najstilizovanije-zene-sveta-koja-je-po-vama-br-1-anketa")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }


}

