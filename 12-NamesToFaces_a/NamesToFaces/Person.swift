//
//  Person.swift
//  NamesToFaces
//
//  Created by Benjamin van den Hout on 21/11/2019.
//  Copyright © 2019 Benjamin van den Hout. All rights reserved.
//

import UIKit

// NSCoding requires 'class' not 'struct'
// NSCoding requires 'NSObject' or else it will crash
class Person: NSObject, NSCoding {
    // Any subclass will definitely need to implement this method
    // Alternative is don't allow subclassing with 'final'
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        image = coder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    var name: String
    var image: String
}
