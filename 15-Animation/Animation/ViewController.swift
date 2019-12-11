//
//  ViewController.swift
//  Animation
//
//  Created by Benjamin van den Hout on 11/12/2019.
//  Copyright © 2019 NGTI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button: UIView!
    var imageView: UIImageView!
    var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isHidden = true

        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                break

            case 1:
                self.imageView.transform = .identity // reset any changes
            default:
                break
            }
        }) { (finished) in
            sender.isHidden = false

            self.currentAnimation += 1

            if self.currentAnimation > 7 {
                self.currentAnimation = 0
            }
        }
    }
}

