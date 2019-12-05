//
//  Person.swift
//  NamesToFaces
//
//  Created by Benjamin van den Hout on 21/11/2019.
//  Copyright © 2019 Benjamin van den Hout. All rights reserved.
//

import UIKit

class Person: NSObject {
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    var name: String
    var image: String

}
