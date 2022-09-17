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
    @IBOutlet weak var ZoomIndicator: UIBarButtonItem!
    @IBOutlet weak var welcomeButton: UIButton!
    @IBOutlet weak var starterView: UIView!
    @IBOutlet weak var webViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var webViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var starterViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var starterViewTrailingConstraint: NSLayoutConstraint!
    
    var isStarterViewSlideOut: Bool = false
    let webViewModel = WebViewModel()
    
    var isStarterView: Bool = true
    var isWebView: Bool = false
    var isFirstLoad: Bool = true
    var isRestoreActive = false
    
    private var viewTracker: PresentedView = .starterView {
        didSet {
            ViewStateUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetUp()
        gestureSetup()
    }
    
    fileprivate func ViewStateUpdate() {
        switch viewTracker {
        case .starterView:
            zoomInButton.isEnabled = false
            zoomOutButton.isEnabled = false
            ZoomIndicator.isEnabled = false
            isStarterView = true
            updateNavButtonsStatus()
        case .webview:
            zoomInButton.isEnabled = true
            zoomOutButton.isEnabled = true
            ZoomIndicator.isEnabled = true
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
        ViewStateUpdate()
    }
    
    fileprivate func zoomRestore() {
        pageZoom = UserDefaults.pageZoom
    }
    
    
    fileprivate func updateNavButtonsStatus() {
        if viewTracker == .starterView && !isFirstLoad {
            forwardButton.isEnabled = true
        } else if webView.canGoForward {
            forwardButton.isEnabled = true
        } else {
            forwardButton.isEnabled = false
        }
        
        if viewTracker == .starterView {
            backButton.isEnabled = false
        } else if webView.canGoBack || isStarterViewSlideOut {
            backButton.isEnabled = true
        } else if !webViewModel.isHistoryEmpty() {
            backButton.isEnabled = true
        } else {
            backButton.isEnabled = false
        }
    }
    
    fileprivate func navForward() {
        if viewTracker == .starterView  {
            slideOut()
            return
        }
        guard webView.canGoForward else {
            ViewStateUpdate()
            return
        }
        webView.goForward()
        ViewStateUpdate()
    }
    
    fileprivate func navWebForward() {
    }
    
    fileprivate func navStarterForward() {
    }
    
    
    fileprivate func navWebBackward() {
        guard webView.canGoBack else {
            slideIn()
            ViewStateUpdate()
            return
        }
        webView.goBack()
        ViewStateUpdate()
    }
    
    fileprivate func navHistoryBackward() {
        webViewModel.removeLastPageAdded()
        guard let nextBackURL = webViewModel.pages.last?.pageURL else { return }
        if nextBackURL == "Favorites" {
            slideIn()
        } else {
            webView.load(nextBackURL)
        }
        ViewStateUpdate()
    }
    
    @objc private func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        guard !isStarterViewSlideOut || !webView.canGoBack  else { return  }
        if (recognizer.direction == .left) {
            navForward()
        }
        
        if (recognizer.direction == .right) {
            if !isRestoreActive {
                navWebBackward()
                ViewStateUpdate()
            } else {
                navHistoryBackward()
                ViewStateUpdate()
            }
        }
    }
    
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
//        if !isRestoreActive {
//            navWebForward()
//            ViewStateUpdate()
//        } else {
//            navStarterForward()
//            ViewStateUpdate()
//        }
        navForward()
        ViewStateUpdate()
    }
    
    var currentItem: WKBackForwardListItem?
    var listData = [WKBackForwardListItem]()
    
    func saveHistory() {
        let bfList = webView.backForwardList
        let items =  bfList.backList + [bfList.currentItem].compactMap({$0})
        listData = items
        listData.forEach {
            webViewModel.savePageVisit(url: $0.url.absoluteString)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if !isRestoreActive {
            navWebBackward()
            ViewStateUpdate()
        } else {
            navHistoryBackward()
            ViewStateUpdate()
        }
        
    }
    
    fileprivate(set) var pageZoom: CGFloat = 1.0 {
        didSet {
            webView?.setValue(pageZoom, forKey: "viewScale")
            zoomInButton.isEnabled = pageZoom != 3.0 && viewTracker == .webview
            zoomOutButton.isEnabled = pageZoom != 0.5 && viewTracker == .webview
            ZoomIndicator.isEnabled = viewTracker == .webview
            ZoomIndicator.title = "  \(Int(pageZoom * 100)) %  "
            UserDefaults.pageZoom = pageZoom
        }
    }
    @objc func zoomIn() {
        switch pageZoom {
        case 0.75:
            pageZoom = 0.85
        case 0.85:
            pageZoom = 1.0
        case 1.0:
            pageZoom = 1.15
        case 1.15:
            pageZoom = 1.25
        case 3.0:
            return
        default:
            pageZoom += 0.25
        }
    }
    
    @objc func zoomOut() {
        switch pageZoom {
        case 0.5:
            return
        case 0.85:
            pageZoom = 0.75
        case 1.0:
            pageZoom = 0.85
        case 1.15:
            pageZoom = 1.0
        case 1.25:
            pageZoom = 1.15
        default:
            pageZoom -= 0.25
        }
    }
    
    func resetZoom() {
        pageZoom = 1.0
    }
    
    @IBAction func zoomOutButtonTapped(_ sender: Any) {
        zoomOut()
    }
    @IBAction func zoomInButtonTapped(_ sender: Any) {
        zoomIn()
    }
    @IBAction func ZoomIndicatorTapped(_ sender: Any) {
        resetZoom()
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
        ViewStateUpdate()
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
        ViewStateUpdate()
    }
    
    @IBAction func welcomeButtonTapped(_ sender: Any) {
        slideOut()
        if isFirstLoad {
            webView.load(K.URL.kagiURL)
            webViewModel.savePageVisit(url: "Favorites")
        }
        isFirstLoad = false
        ViewStateUpdate()
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        zoomRestore()
        ViewStateUpdate()
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
            isRestoreActive = true
            ViewStateUpdate()
        }
    }
}
