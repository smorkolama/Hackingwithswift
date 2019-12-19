//
//  ViewController.swift
//  Debugging
//
//  Created by Benjamin van den Hout on 19/12/2019.
//  Copyright © 2019 NGTI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // print() is variadic, also can add separator and terminator
        print(1, 2, 3, 4, 5, separator: "-", terminator: ".")

        assert(1 == 1, "Maths failure!")
//        assert(1 == 2, "Maths failure!")

        for i in 1...100 {
            print("Got number \(i)")
        }
    }


}

