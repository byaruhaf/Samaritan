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
    @IBOutlet weak var starterView: UIView!

    var currentZoom:CGFloat = 0.0
    let webViewModel = WebViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetUp()
        gestureSetup()
    }
    
    fileprivate func gestureSetup() {
        webView.allowsBackForwardNavigationGestures = true
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
        webView.backgroundColor = .red
        view.backgroundColor = .blue
        currentZoom = webView.scrollView.zoomScale
        //        webView.load(K.URL.googleURL)
        //        webView.load("http://192.168.1.1/index.html#login")
        //        webView.load("http://192.168.1.1:8000/webman/index.cgi")
        //        webView.load("xxxxxxxxxxxxxxxxxxxx")
        webView.isHidden = true
        updateNavButtonsStatus()
    }
    
    fileprivate func updateNavButtonsStatus() {
        if webView.canGoForward {
            forwardButton.isEnabled = true
        } else {
            forwardButton.isEnabled = false
        }
        if webView.canGoBack || welcomeButton.isHidden {
            backButton.isEnabled = true
        } else {
            backButton.isEnabled = false
        }
    }
    
    fileprivate func navForward() {
        guard webView.canGoForward else {return}
        webView.fadeIn(0.5)
        welcomeButton.fadeOut(0.5)
            webView.goForward()
        updateNavButtonsStatus()
    }
    
    fileprivate func navBackward() {
        guard webView.canGoBack else {
            welcomeButton.fadeIn(0.5)
            webView.fadeOut(0.5)
            updateNavButtonsStatus()
            return
        }
        webView.goBack()
        updateNavButtonsStatus()
        webViewModel.removeLastPageAdded()
    }
    
    @objc private func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        guard webView.isHidden || !webView.canGoBack  else { return  }
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
        webView.fadeIn(0.5)
        navToolBar.fadeIn(0.5)
        welcomeButton.fadeOut(0.5)
        //webView.load("http://192.168.1.1/index.html#login")
        webView.load(K.URL.googleURL)
        updateNavButtonsStatus()
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




//func setupWebView() {
//    webview.translatesAutoresizingMaskIntoConstraints = false
//    let keys = [
//        "offlineApplicationCacheIsEnabled",
//        "aggressiveTileRetentionEnabled",
//        "screenCaptureEnabled",
//        "allowsPictureInPictureMediaPlayback",
//        "fullScreenEnabled",
//        "largeImageAsyncDecodingEnabled",
//        "animatedImageAsyncDecodingEnabled",
//        "developerExtrasEnabled",
//        "usesPageCache",
//        "mediaSourceEnabled",
//        "mockCaptureDevicesPromptEnabled",
//        "canvasUsesAcceleratedDrawing",
//        "videoQualityIncludesDisplayCompositingEnabled",
//        "backspaceKeyNavigationEnabled"
//    ]
//    let preferences = webview.configuration.preferences
//    for index in 0..<keys.count {
//        guard preferences.value(forKey: keys[index]) != nil else {
//            continue
//        }
//        preferences.setValue(
//            index != keys.count-1 ? true : false,
//            forKey: keys[index]
//        )
//    }
//    preferences.javaScriptCanOpenWindowsAutomatically = true
//    webview.configuration.suppressesIncrementalRendering = true
//    webview.customUserAgent = safariUA
//}
