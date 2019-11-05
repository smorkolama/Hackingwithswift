//
//  ViewController.swift
//  StormViewer
//
//  Created by Benjamin van den Hout on 24/10/2019.
//  Copyright © 2019 NGTI. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true // try to set to false to see the difference, only recommended for first screen

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped2))

        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        for item in items {
            if item.hasPrefix("nssl") {
                // load picture
                pictures.append(item)
            }
        }
//        print(pictures)
        pictures.sort()
    }

    // MARK: Tableview

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.imageTitle = "\(pictures[indexPath.row]) (\(indexPath.row+1) of \(pictures.count))"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // share
    @objc func shareTapped() {
        if let name = URL(string: "https://www.smork.info") {
            
            let vc = UIActivityViewController(activityItems: [name], applicationActivities: [])
            // BEN: only relevant for iPad but still needed otherwise it will crash (only on iPad) with "UIPopoverPresentationController (<UIPopoverPresentationController: 0x7ff771d58b80>) should have a non-nil sourceView or barButtonItem set before the presentation occurs."
            vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            present(vc, animated: true)
        }
    }
    @objc func shareTapped2() {
        let name = "Learn all about this StormViewer app at https://www.smork.info"
        let vc = UIActivityViewController(activityItems: [name], applicationActivities: [])
        // BEN: only relevant for iPad but still needed otherwise it will crash (only on iPad) with "UIPopoverPresentationController (<UIPopoverPresentationController: 0x7ff771d58b80>) should have a non-nil sourceView or barButtonItem set before the presentation occurs."
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}

