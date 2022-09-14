//
//  ViewController.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 12/09/2022.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var navToolBar: UIToolbar!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var zoomOutButton: UIBarButtonItem!
    @IBOutlet weak var zoomInButton: UIBarButtonItem!
    @IBOutlet weak var welcomeButton: UIButton!
    var currentZoom:CGFloat = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.scrollView.maximumZoomScale = 20
        webView.scrollView.minimumZoomScale = 1
        currentZoom = webView.scrollView.zoomScale
        
        
        webView.load("https://stil.kurir.rs/moda/157971/ovo-su-najstilizovanije-zene-sveta-koja-je-po-vama-br-1-anketa")
        //        webView.allowsBackForwardNavigationGestures = true
        webView.isHidden = true
        navToolBar.isHidden = true
        updateNavButtons()
        
        //        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
        //        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)
        
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        swipeLeftRecognizer.direction = .left
        swipeRightRecognizer.direction = .right
        
        webView.addGestureRecognizer(swipeLeftRecognizer)
        webView.addGestureRecognizer(swipeRightRecognizer)
    }
    
    //    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    //        if let _ = object as? WKWebView {
    //            if keyPath != #keyPath(WKWebView.canGoBack) {
    //                print("Cant go Back")
    //            }
    //        }
    //    }
    //
    //    deinit {
    //        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack))
    //        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward))
    //    }
    
    
    @objc private func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        if (recognizer.direction == .left) {
            print("Left Left Left Left ")
            if webView.canGoForward {
                webView.isHidden = false
                welcomeButton.isHidden = true
                webView.goForward()
            } else {
                print("Cant go Forward")
            }
        }
        
        if (recognizer.direction == .right) {
            if webView.canGoBack {
                webView.goBack()
            } else {
                //            print("Cant go Back")
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
            //            print("Cant go Back")
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
    
    
    @IBAction func zoomOutButtonTapped(_ sender: Any) {
        print("Zoom OUT")
        print(currentZoom)
        currentZoom -= 1
        self.webView.scrollView.setZoomScale(currentZoom, animated: true)
    }
    @IBAction func zoomInButtonTapped(_ sender: Any) {
        print("Zoom IN")
        print(currentZoom)
        currentZoom += 1
        self.webView.scrollView.setZoomScale(currentZoom, animated: true)
    }
    
    
    @IBAction func welcomeButtonTapped(_ sender: Any) {
        webView.isHidden = false
        navToolBar.isHidden = false
        welcomeButton.isHidden = true
    }
    
    func updateNavButtons() {
        //        forwardButton.isEnabled = false
        //        backButton.isEnabled = false
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
