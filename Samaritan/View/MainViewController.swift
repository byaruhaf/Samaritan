//
//  MainViewController.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 12/09/2022.
//

import UIKit
import WebKit


class MainViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var navToolBar: UIToolbar!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var zoomOutButton: UIBarButtonItem!
    @IBOutlet weak var zoomInButton: UIBarButtonItem!
    @IBOutlet weak var welcomeButton: UIButton!
    var currentZoom:CGFloat = 0.0
    let webViewModel = WebViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetUp()
        
        //        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
        //        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)
        
//        self.backButton?.isEnabled = self.webView.canGoBack
//        self.forwardButton?.isEnabled = self.webView.canGoForward
//        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack), options: .new, context: nil)
//        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward), options: .new, context: nil)
//
        
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        swipeLeftRecognizer.direction = .left
        swipeRightRecognizer.direction = .right
        self.view.addGestureRecognizer(swipeLeftRecognizer)
        self.view.addGestureRecognizer(swipeRightRecognizer)
        
    }
    
    fileprivate func viewSetUp() {
        // Do any additional setup after loading the view.
        welcomeButton.titleLabel?.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        welcomeButton.pulsate()
        welcomeButton.roundCorners()
        welcomeButton.setBorder(color: .blue, width: 2.0)
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.scrollView.maximumZoomScale = 20
        webView.scrollView.minimumZoomScale = 1
        webView.backgroundColor = .systemGray
        currentZoom = webView.scrollView.zoomScale
//        webView.load(K.URL.googleURL)
//        webView.load("http://192.168.1.1/index.html#login")
        webView.load("http://192.168.1.1:8000/webman/index.cgi")
//        webView.load("xxxxxxxxxxxxxxxxxxxx")
        webView.allowsBackForwardNavigationGestures = true
        webView.isHidden = true
        navToolBar.isHidden = true
        updateNavButtonsStatus()
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
//        if let _ = object as? WKWebView {
//            if keyPath == #keyPath(WKWebView.canGoBack) {
//                self.backButton?.isEnabled = self.webView.canGoBack
//            } else if keyPath == #keyPath(WKWebView.canGoForward) {
//                self.forwardButton?.isEnabled = self.webView.canGoForward
//            }
//        }
//    }
//
    //    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    //        if let _ = object as? WKWebView {
    //            if keyPath != #keyPath(WKWebView.canGoBack) {
    //                print("Cant go Back")
    //            }
    //        }
    //    }

    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.canGoBack))
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.canGoForward))
    }
    
    fileprivate func updateNavButtonsStatus() {
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
    
    fileprivate func navForward() {
        if webView.canGoForward {
            webView.isHidden = false
            welcomeButton.isHidden = true
            webView.goForward()
        } else {
            print("Cant go Forward")
        }
    }
    
    fileprivate func navBackward() {
        if webView.canGoBack {
            webView.goBack()
            webViewModel.removeLastPageAdded()
        } else {
            welcomeButton.isHidden = false
            webView.isHidden = true
            
            if webView.canGoForward {
                navToolBar.isHidden = false
                updateNavButtonsStatus()
            } else {
                navToolBar.isHidden = true
                updateNavButtonsStatus()
            }
        }
    }
    
    @objc private func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        if (recognizer.direction == .left) {
            navForward()
        }
        
        if (recognizer.direction == .right) {
            navBackward()
        }
    }
    
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        navForward()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navBackward()
    }
    
    
    @IBAction func zoomOutButtonTapped(_ sender: Any) {
        currentZoom -= 1
        self.webView.scrollView.setZoomScale(currentZoom, animated: true)
    }
    @IBAction func zoomInButtonTapped(_ sender: Any) {
        currentZoom += 1
        self.webView.scrollView.setZoomScale(currentZoom, animated: true)
    }
    
    
    @IBAction func welcomeButtonTapped(_ sender: Any) {
        webView.isHidden = false
        navToolBar.isHidden = false
        welcomeButton.isHidden = true
//        webView.load("http://192.168.1.1/index.html#login")
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateNavButtonsStatus()
        webViewModel.savePageVisit(url: webView.url?.absoluteString, pageTitle: webView.title)
    }
    
}


extension MainViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        return WKWebView(frame: webView.frame, configuration: configuration)
    }
}



