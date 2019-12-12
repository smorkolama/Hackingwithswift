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
    var currentAnimation = 0
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView.image = UIImage(named: "penguin")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ]);
        view.addSubview(imageView)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        sender.isHidden = true

//        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            switch self.currentAnimation {
            case 0:
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2) // make bigger
                break

            case 2:
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256) // move
                
            case 4:
                self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi) // pi is 180 degrees
                
            case 6:
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = UIColor.green
                
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = UIColor.clear
                
            case 1,3,5:
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

