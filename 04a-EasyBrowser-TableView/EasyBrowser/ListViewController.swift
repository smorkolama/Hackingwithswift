//
//  ViewController.swift
//  EasyBrowser
//
//  Created by Benjamin van den Hout on 05/11/2019.
//  Copyright © 2019 Benjamin van den Hout. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {

    var websites = ["apple.com", "hackingwithswift.com", "www.smork.info/blog/"]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Easy Web Browser"

        // Do any additional setup after loading the view.
    }
    
    // MARK: Tableview

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? WebViewController {
            vc.selectedWebsite = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
