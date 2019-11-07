//
//  Petition.swift
//  WhitehousePetitions
//
//  Created by Benjamin van den Hout on 07/11/2019.
//  Copyright © 2019 NGTI. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
