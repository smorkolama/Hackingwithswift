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
        title = "Cat Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true // try to set to false to see the difference, only recommended for first screen
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        for item in items {
            if item.hasPrefix("cat") {
                // load picture
                pictures.append(item)
            }
        }
//        print(pictures)
        pictures = pictures.sortedByNumberAndString
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
}

extension Sequence where Iterator.Element == String {
    var sortedByNumberAndString : [String] {
        return self.sorted { (s1, s2) -> Bool in
            return s1.compare(s2, options: .numeric) == .orderedAscending
        }
    }
}
