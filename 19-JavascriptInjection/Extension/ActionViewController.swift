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

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(edit))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyBoard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyBoard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

    }

    @objc func adjustForKeyBoard(notification: Notification) {
        // get frame of keyboard when it has finished animating
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return } // NSValue with CGRect inside
        let keyboardScreenEndFrame = keyboardValue.cgRectValue

        // convert to our view's coordinates (handles rotation where height and width are flipped)
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            // account for keyboard, substract view.safeAreaInsets.bottom or else text will scroll before it reaches the keyboard (just remove and try it)
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        // match the contentInset to save time
        script.scrollIndicatorInsets = script.contentInset

        // make sure cursor is still visible
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
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

    @objc func edit() {
        let ac = UIAlertController(title: "Sample scripts", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Print title", style: .default, handler: { [weak self] _ in
            self?.script.text = "alert(document.title)"
        }))
        ac.addAction(UIAlertAction(title: "Something else", style: .default, handler: { [weak self] _ in
            self?.script.text = "alert(\"hello\")"
        }))
        ac.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(ac, animated: true)
    }
}
