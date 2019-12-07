//
//  Image.swift
//  Challenge4
//
//  Created by Ayax Alexis Casarrubias Rodríguez on 06/12/19.
//  Copyright © 2019 Ayax Alexis. All rights reserved.
//

import UIKit

class Image: NSObject, Codable {
    var caption : String
    var image : String
    
    init(caption: String, image: String) {
        self.caption = caption
        self.image = image
    }
    
}
