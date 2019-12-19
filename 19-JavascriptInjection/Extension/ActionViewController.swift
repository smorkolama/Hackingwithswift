//
//  ActionViewController.swift
//  Extension
//
//  Created by Benjamin van den Hout on 19/12/2019.
//  Copyright © 2019 NGTI. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    @IBOutlet var script: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    var pageTitle = ""
    var pageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // NOTE: look at apple reference code in newly created extension to see how to properly do this without shortcuts!

        // extensionContext conrols how we interact with parent app
        // inputItems is array of data parent app sends to the extension
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            // pull out first attachment
            if let itemProvider = inputItem.attachments?.first {
                // provide us with item, async
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    print(itemDictionary)
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    print(javaScriptValues)
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""

                    // Should always be on main thread, current closure can be called on any thread
                    DispatchQueue.main.async { // no [weak self] necessary, it's already weak from current closure
                        self?.title = self?.pageTitle
                    }
                }
            }
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    }

    // in the end this will call the finalize() function in javascript
    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript" : script.text ?? ""]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey : argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]

        extensionContext?.completeRequest(returningItems: [item])
    }

}
