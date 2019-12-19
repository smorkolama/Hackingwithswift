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

    @IBOutlet weak var imageView: UIImageView!

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
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    print(javaScriptValues)
                }
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
