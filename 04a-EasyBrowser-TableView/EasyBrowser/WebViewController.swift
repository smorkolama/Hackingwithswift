//
//  ViewController.swift
//  EasyBrowser
//
//  Created by Benjamin van den Hout on 31/10/2019.
//  Copyright © 2019 Benjamin van den Hout. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var ac: UIAlertController?
    var selectedWebsite: String?

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
//        progressView.progressViewStyle = .bar
        let progressButton = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        guard let selectedWebsite = selectedWebsite else {
            print("No website specified, can't load")
            return
        }

        // Do any additional setup after loading the view.
        guard let url = URL(string: "https://" + selectedWebsite) else {
            print("Could not create URL")
            return
        }
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil) // only want new value in dictionary
        
        print("OPEN: \(url)")
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    // Not really necessary here but important to balance things!
    override func viewWillDisappear(_ animated: Bool) {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }

    func openPage(action: UIAlertAction) {
        guard let title = action.title else {
            print("Action has no title")
            return
        }
        
        guard let url = URL(string: "https://" + title) else {
            print("Could not create URL")
            return
        }
        
        // alternative as indicated by the book:
//        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    // KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("KVO keypath: \(String(describing: keyPath)) change: \(String(describing: change))")
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress) // convert Double to Float
            
            if webView.estimatedProgress == 1.0 {
                progressView.progress = 0.0
            }
        }
    }
}
