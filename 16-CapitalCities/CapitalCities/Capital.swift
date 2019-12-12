//
//  Capital.swift
//  CapitalCities
//
//  Created by Benjamin van den Hout on 12/12/2019.
//  Copyright © 2019 Benjamin van den Hout. All rights reserved.
//

import UIKit
import MapKit

// Notice that this is not a subclass, it implements MKAnnotation protocol!
class Capital: NSObject, MKAnnotation {
    init(title: String?, coordinate: CLLocationCoordinate2D, info: String, wikiURL: URL?) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        self.wikiURL = wikiURL
    }
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    var wikiURL: URL?
    
    var subtitle: String? {
        return info
    }
    
    
}
