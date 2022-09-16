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
    @IBOutlet weak var zoomLabel: UILabel!
    
    @IBOutlet weak var webViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var webViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var starterViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var starterViewTrailingConstraint: NSLayoutConstraint!
    
    var currentZoom:CGFloat = 0.0
    var isStarterViewSlideOut: Bool = false
    let webViewModel = WebViewModel()
    
    var isStarterView: Bool = true
    var isWebView: Bool = false
    var isFirstLoad: Bool = true
    
    private var viewTracker: PresentedView = .starterView {
        didSet {
            ViewStateUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetUp()
        gestureSetup()
        print(webViewModel.pages.count)
    }
    
    fileprivate func ViewStateUpdate() {
        switch viewTracker {
        case .starterView:
            zoomInButton.isEnabled = false
            zoomOutButton.isEnabled = false
            isStarterView = true
            updateNavButtonsStatus()
        case .webview:
            zoomInButton.isEnabled = true
            zoomOutButton.isEnabled = true
            updateNavButtonsStatus()
            isWebView = true
        }
    }
    
    fileprivate func gestureSetup() {
        webView.allowsBackForwardNavigationGestures = true
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(recognizer:)))
        swipeLeftRecognizer.direction = .left
        swipeRightRecognizer.direction = .right
        self.starterView.addGestureRecognizer(swipeLeftRecognizer)
        self.starterView.addGestureRecognizer(swipeRightRecognizer)
        self.view.addGestureRecognizer(swipeLeftRecognizer)
        self.view.addGestureRecognizer(swipeRightRecognizer)
    }
    
    fileprivate func welcomeButtonSetUp() {
        welcomeButton.imageView?.image = UIImage(named: "kagi")
        welcomeButton.titleLabel?.text = ""
        welcomeButton.clipsToBounds = true
        welcomeButton.contentMode = .scaleAspectFit
        welcomeButton.roundCorners()
        welcomeButton.setBorder(color: .lightGray, width: 8.0)
        starterView.backgroundColor = .darkGray
        starterView.backgroundColor = .blue
    }
    
    fileprivate func viewSetUp() {
        // Do any additional setup after loading the view.
        welcomeButtonSetUp()
        welcomeButton.pulsate()
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        webView.scrollView.maximumZoomScale = 20
        webView.scrollView.minimumZoomScale = 1
        webView.backgroundColor = .clear
        webView.isOpaque = true
        //        webView.backgroundColor = .red
        //        webView.restorationIdentifier = "webviewrestoration"
        zoomRestore()
        zoomLabel.roundCorners()
        zoomLabel.alpha = 0
        zoomLabel.isHidden = true
        ViewStateUpdate()
    }
    
    fileprivate func zoomRestore() {
        guard let savedZoom = UserDefaults.getZoomValue() else {
            currentZoom = webView.scrollView.zoomScale
            zoomLabel.text = "  \(Int(currentZoom)) X  "
            return
        }
        currentZoom = savedZoom
        zoomLabel.text = "  \(Int(currentZoom)) X  "
        self.webView.scrollView.setZoomScale(currentZoom, animated: true)
    }
    
    
    fileprivate func updateNavButtonsStatus() {
        
        if webView.canGoForward || !isStarterViewSlideOut{
            forwardButton.isEnabled = true
        } else {
            forwardButton.isEnabled = false
        }
        if webView.canGoBack || isStarterViewSlideOut {
            backButton.isEnabled = true
        } else {
            backButton.isEnabled = false
        }
    }
    
    fileprivate func navForward() {
        guard webView.canGoForward else {return}
        if !isStarterViewSlideOut{
            slideOut()
        }
        webView.goForward()
        ViewStateUpdate()
    }
    
    fileprivate func navBackward() {
        guard webView.canGoBack else {
            slideIn()
            ViewStateUpdate()
            return
        }
        webView.goBack()
        ViewStateUpdate()
        webViewModel.removeLastPageAdded()
    }
    
    @objc private func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        guard !isStarterViewSlideOut || !webView.canGoBack  else { return  }
        if (recognizer.direction == .left) {
            navForward()
        }
        
        if (recognizer.direction == .right) {
            navBackward()
        }
    }
    
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        navForward()
        ViewStateUpdate()
    }
    
    func saveHistory() {
        loadSites(webView.backForwardList)
        listData.forEach {
            print($0.url.absoluteString)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navBackward()
        ViewStateUpdate()
        
        
    }
    
    
    @IBAction func zoomOutButtonTapped(_ sender: Any) {
        guard currentZoom > 1 else {
            zoomOutButton.isEnabled = false
            return
        }
        ViewStateUpdate()
        zoomLabel.fadeIn()
        currentZoom -= 1
        self.webView.scrollView.setZoomScale(currentZoom, animated: true)
        zoomLabel.text = "  \(Int(currentZoom)) X  "
        UserDefaults.set(currentZoom: currentZoom)
        //        zoomLabel.fadeOut(8)
    }
    @IBAction func zoomInButtonTapped(_ sender: Any) {
        guard currentZoom < 5 else {
            zoomInButton.isEnabled = false
            return
        }
        ViewStateUpdate()
        zoomLabel.fadeIn()
        currentZoom += 1
        self.webView.scrollView.setZoomScale(currentZoom, animated: true)
        zoomLabel.text = "  \(Int(currentZoom)) X  "
        UserDefaults.set(currentZoom: currentZoom)
        //        zoomLabel.fadeOut(8)
    }
    
    
    fileprivate func slideOut() {
        UIView.animate(withDuration: 0.75, delay: 0.0, options: .curveEaseOut, animations: {
            self.starterViewLeadingConstraint.constant = -2000
            self.starterViewTrailingConstraint.constant = 2000
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.viewTracker = .webview
            self.ViewStateUpdate()
        })
    }
    
    fileprivate func slideIn() {
        UIView.animate(withDuration: 0.75, delay: 0.0, options: .curveEaseOut, animations: {
            self.starterViewLeadingConstraint.constant = 0
            self.starterViewTrailingConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { finished in
            self.viewTracker = .starterView
            self.ViewStateUpdate()
        })
        
    }
    
    @IBAction func welcomeButtonTapped(_ sender: Any) {
        slideOut()
        if isFirstLoad {
            webView.load(K.URL.kagiURL)
            webViewModel.savePageVisit(url: "Favorites", pageTitle: "Favorites")
        }
        
        zoomRestore()
        ViewStateUpdate()
        
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ViewStateUpdate()
        webViewModel.savePageVisit(url: webView.url?.absoluteString, pageTitle: webView.title)
    }
    
    var currentItem: WKBackForwardListItem?
    var listData = [WKBackForwardListItem]()
    
    func homeAndNormalPagesOnly(_ bfList: WKBackForwardList) {
        let items = bfList.forwardList.reversed() + [bfList.currentItem].compactMap({$0}) + bfList.backList.reversed()
        listData = items
    }
    
    func loadSites(_ bfList: WKBackForwardList) {
        currentItem = bfList.currentItem
        
        homeAndNormalPagesOnly(bfList)
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




extension MainViewController {
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        webView.encodeRestorableState(with: coder)
        let lastURL = webView.backForwardList.currentItem?.url
        let lastSite = lastURL?.absoluteString
        coder.encode(lastSite, forKey: "lastSite")
        saveHistory()
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        webView.decodeRestorableState(with: coder)
        
        if let lastSite = coder.decodeObject(forKey: "lastSite") as? String {
            slideOut()
            webView.load(lastSite)
        }
    }
}
