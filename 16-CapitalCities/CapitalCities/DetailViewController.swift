//
//  DetailViewController.swift
//  CapitalCities
//
//  Created by Benjamin van den Hout on 12/12/2019.
//  Copyright © 2019 Benjamin van den Hout. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Capital?

    override func loadView() {
        webView = WKWebView()
        view = webView
        // Your custom implementation of this method should not call super.
        guard let detailItem = detailItem else { return }
        guard let url = detailItem.wikiURL else { return }
        let req = URLRequest(url: url)
        webView.load(req)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
