//
//  ViewController.swift
//  StormViewer
//
//  Created by Benjamin van den Hout on 24/10/2019.
//  Copyright © 2019 NGTI. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Storm Viewer"
//        navigationController?.navigationBar.prefersLargeTitles = true // try to set to false to see the difference, only recommended for first screen
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

    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Pictures: \(pictures.count)")
        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else {
            fatalError("Unable to dequeue Picture")
        }

        let picture = pictures[indexPath.item]
        cell.name.text = picture
        cell.imageView.image = UIImage(named: picture)

        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor // useful if you want only grayscale colors
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.item]
            vc.imageTitle = "\(pictures[indexPath.item]) (\(indexPath.item+1) of \(pictures.count))"
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

