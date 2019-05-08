//
//  UnsplashImage.swift
//  DominantImageIdentifier
//
//  Created by sonalojha on 04/05/19.
//  Copyright © 2019 anuragojha. All rights reserved.
//

import Foundation
import UIKit

class UnsplashImage: NSObject {
    lazy var thumbImage = UIImage()
    var thumbImageUrl:String = ""
    var fullResolutionImageUrl:String = ""
    var imageDescription:String = ""
}

struct Response:Decodable {
    var results:[Photos]?
}

struct Photos:Decodable {
    var alt_description:String?
    var urls:URLS?
    
}

struct URLS:Decodable {
    var thumb:String?
    var regular:String?
}
