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
    var websites = ["apple.com", "hackingwithswift.com"]
    var ac: UIAlertController?

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        toolbarItems = [progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false
        
        // Do any additional setup after loading the view.
        guard let url = URL(string: "https://" + websites[0]) else {
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

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated:true)
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
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        let url = navigationAction.request.url
//        print(String(describing: url))
//
//        if let host = url?.host {
//            for website in websites {
//                if host.contains(website) {
//                    decisionHandler(.allow)
//                    return;
//                }
//            }
//        }
//
//        if let url = url {
//        let ac = UIAlertController(title: nil, message: "Sorry, not allowed to visit \(url).", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (UIAlertAction) in
//            }))
//            present(ac, animated: true)
//        }
//        decisionHandler(.cancel)
//
//    }
    
    

    // KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("KVO keypath: \(String(describing: keyPath)) change: \(String(describing: change))")
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress) // convert Double to Float
        }
    }
}
