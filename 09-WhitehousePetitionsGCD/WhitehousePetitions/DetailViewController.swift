//
//  DetailViewController.swift
//  WhitehousePetitions
//
//  Created by Benjamin van den Hout on 07/11/2019.
//  Copyright © 2019 NGTI. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?

    override func loadView() {
        webView = WKWebView()
        view = webView
        // Your custom implementation of this method should not call super.
        guard let detailItem = detailItem else { return }

        let html = """
<html>
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; }</style>
    </head>
    <body>
    <b>\(detailItem.title)</b></br>
    <i>Signature count: \(detailItem.signatureCount)</i><br><br>
    \(detailItem.body)
    </body>
</html>
"""
        webView.loadHTMLString(html, baseURL: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
