//
//  ViewController.swift
//  Project6b
//
//  Created by Benjamin van den Hout on 07/11/2019.
//  Copyright © 2019 NGTI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let label1 = UILabel()
        // will do it by hand, normally iOS generates constraints based on size and position
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = UIColor.red
        label1.text = "THESE"
        label1.sizeToFit()

        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.cyan
        label2.text = "ARE"
        label2.sizeToFit()

        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.yellow
        label3.text = "SOME"
        label3.sizeToFit()

        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.green
        label4.text = "AWESOME"
        label4.sizeToFit()

        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orange
        label5.text = "LABELS"
        label5.sizeToFit()

        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)

        let viewsDictionary = ["label1": label1,
                               "label2": label2,
                               "label3": label3,
                               "label4": label4,
                               "label5": label5]

        // Horizontal
        for label in viewsDictionary.keys {
            // Visual Format Language can generate multiple constraints at at time
            // NSLayoutConstraint.constraints converts VFL into array of constraints
            // 'H:' horizontal, '|' is edge of view
            // Additional 2: disabled
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
        }

        // Vertical
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1]-[label2]-[label3]-[label4]-[label5]", options: [], metrics: nil, views: viewsDictionary))

        // Bottom of last label must be at least 10 points away from bottom for view controller view, labels are height 88
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(==88)]-[label2(==88)]-[label3(==88)]-[label4(==88)]-[label5(==88)]-(>=10)-|", options: [], metrics: nil, views: viewsDictionary))

        // Add labelheight as a metrics dict
//        let metrics = ["labelHeight": 88]
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(==labelHeight)]-[label2(==labelHeight)]-[label3(==labelHeight)]-[label4(==labelHeight)]-[label5(==labelHeight)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))

        // Add height with less prio in the first label, and make other labels adopt the same height
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]->=10-|", options: [], metrics: metrics, views: viewsDictionary))

        // Anchors but all on top of each other
//        for label in [label1, label2, label3, label4, label5] {
//            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//            label.heightAnchor.constraint(equalToConstant: 88).isActive = true
//        }

        // Anchor label to previous one
//        var previous: UILabel?
//        for label in [label1, label2, label3, label4, label5] {
//            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//            label.heightAnchor.constraint(equalToConstant: 88).isActive = true
//
//            if let previous = previous {
//                // Create height constraint on previous label
//                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
//            } else { // fix safe area for first label
//                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//            }
//
//            // set previous label to be current one
//            previous = label
//        }

//        // Anchor label to previous one, additional: use leading/trailing anchors of parent view
//        var previous: UILabel?
//        for label in [label1, label2, label3, label4, label5] {
//            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
//            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
//            label.heightAnchor.constraint(equalToConstant: 88).isActive = true
//
//            if let previous = previous {
//                // Create height constraint on previous label
//                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
//            } else { // fix safe area for first label
//                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//            }
//
//            // set previous label to be current one
//            previous = label
//        }

        // Anchor label to previous one, additional: use leading/trailing anchors of safe area
        var previous: UILabel?
        for label in [label1, label2, label3, label4, label5] {
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
            // multiply height by 0,2 add substract 10 for the height
            label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: -10).isActive = true

            if let previous = previous {
                // Create height constraint on previous label
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else { // fix safe area for first label
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }

            // set previous label to be current one
            previous = label
        }

    }
}

