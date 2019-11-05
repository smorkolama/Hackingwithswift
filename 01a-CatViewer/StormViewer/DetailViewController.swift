//
//  DetailViewController.swift
//  StormViewer
//
//  Created by Benjamin van den Hout on 24/10/2019.
//  Copyright © 2019 NGTI. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var imageTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = imageTitle
        if let imageToLoad = selectedImage {
            let gif = UIImage.gifImageWithName(imageToLoad.replacingOccurrences(of: ".gif", with: ""))
            imageView.image = gif
        }
        navigationController?.hidesBarsOnTap = true
        navigationItem.largeTitleDisplayMode = .never // Override large title mode
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
