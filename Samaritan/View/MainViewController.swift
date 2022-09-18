//
//  MainViewController.swift
//  Samaritan
//
//  Created by Franklin Byaruhanga on 12/09/2022.
//

import UIKit
import WebKit

class MainViewController: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {
    @IBOutlet var webView: WKWebView!
    @IBOutlet var navToolBar: UIToolbar!
    @IBOutlet var forwardButton: UIBarButtonItem!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var zoomOutButton: UIBarButtonItem!
    @IBOutlet var zoomInButton: UIBarButtonItem!
    @IBOutlet var zoomIndicator: UIBarButtonItem!
    @IBOutlet var welcomeButton: UIButton!
    @IBOutlet var starterView: UIView!
    @IBOutlet var webViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var webViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var starterViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var starterViewTrailingConstraint: NSLayoutConstraint!
    
    var isStarterViewSlideOut = false
    let webViewModel = WebViewModel()
    
    var isStarterView = true
    var isWebView = false
    var isFirstLoad = true
    var isRestoreActive = false
    
    private var viewTracker: PresentedView = .starterView {
        didSet {
            viewStateUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetUp()
        gestureSetup()
    }
    
    fileprivate func viewStateUpdate() {
        switch viewTracker {
        case .starterView:
            zoomInButton.isEnabled = false
            zoomOutButton.isEnabled = false
            zoomIndicator.isEnabled = false
            isStarterView = true
            updateNavButtonsStatus()
        case .webview:
            zoomInButton.isEnabled = true
            zoomOutButton.isEnabled = true
            zoomIndicator.isEnabled = true
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
        viewStateUpdate()
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
        if viewTracker == .starterView {
            slideOut()
            return
        }
        guard webView.canGoForward else {
            viewStateUpdate()
            return
        }
        webView.goForward()
        viewStateUpdate()
    }
    
    fileprivate func navWebBackward() {
        guard webView.canGoBack else {
            slideIn()
            viewStateUpdate()
            return
        }
        webView.goBack()
        viewStateUpdate()
    }
    
    fileprivate func navHistoryBackward() {
        webViewModel.removeLastPageAdded()
        guard let nextBackURL = webViewModel.pages.last?.pageURL else { return }
        if nextBackURL == "Favorites" {
            slideIn()
        } else {
            webView.load(nextBackURL)
        }
        viewStateUpdate()
    }
    
    @objc private func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        guard  !isFirstLoad  else { return }
        guard viewTracker == .starterView || !webView.canGoBack  else { return  }
        if recognizer.direction == .left {
            navForward()
        }
        
        if recognizer.direction == .right {
            if !isRestoreActive {
                navWebBackward()
                viewStateUpdate()
            } else {
                navHistoryBackward()
                viewStateUpdate()
            }
        }
    }
    
    @IBAction private func forwardButtonTapped(_ sender: Any) {
        navForward()
        viewStateUpdate()
    }
    
    func saveHistory() {
        let bfList = webView.backForwardList
        let items = bfList.backList + [bfList.currentItem].compactMap({ $0 })
        items.forEach {
            webViewModel.savePageVisit(url: $0.url.absoluteString)
        }
    }
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        if !isRestoreActive {
            navWebBackward()
            viewStateUpdate()
        } else {
            navHistoryBackward()
            viewStateUpdate()
        }
    }
    
    fileprivate(set) var pageZoom: CGFloat = 1.0 {
        didSet {
            webView?.setValue(pageZoom, forKey: "viewScale")
            zoomInButton.isEnabled = pageZoom != 3.0 && viewTracker == .webview
            zoomOutButton.isEnabled = pageZoom != 0.5 && viewTracker == .webview
            zoomIndicator.isEnabled = viewTracker == .webview
            zoomIndicator.title = "  \(Int(pageZoom * 100)) %  "
            UserDefaults.pageZoom = pageZoom
        }
    }
    
    func zoomIn() {
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
    
    func zoomOut() {
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
    
    @IBAction private func zoomOutButtonTapped(_ sender: Any) {
        zoomOut()
    }
    @IBAction private func zoomInButtonTapped(_ sender: Any) {
        zoomIn()
    }
    @IBAction private func zoomIndicatorTapped(_ sender: Any) {
        resetZoom()
    }
    
    fileprivate func slideOut() {
        UIView.animate(withDuration: 1.8,
                       delay: 0.01,
                       options: .curveLinear,
                       animations: {
            self.starterViewLeadingConstraint.constant = -2000
            self.starterViewTrailingConstraint.constant = 2000
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.viewTracker = .webview
            self.viewStateUpdate()
        })
        viewStateUpdate()
    }
    
    fileprivate func slideIn() {
        UIView.animate(withDuration: 1.8,
                       delay: 0.01,
                       options: .curveLinear,
                       animations: {
            self.starterViewLeadingConstraint.constant = 0
            self.starterViewTrailingConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.viewTracker = .starterView
            self.viewStateUpdate()
        })
        viewStateUpdate()
    }
    
    @IBAction private func welcomeButtonTapped(_ sender: Any) {
        slideOut()
        if isFirstLoad {
            webView.load(Konstant.URL.kagiURL)
            webViewModel.savePageVisit(url: "Favorites")
        }
        isFirstLoad = false
        viewStateUpdate()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        zoomRestore()
        viewStateUpdate()
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
            viewStateUpdate()
        }
    }
}
