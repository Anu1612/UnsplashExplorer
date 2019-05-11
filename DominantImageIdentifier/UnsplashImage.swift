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
    var user:String = ""
    var userProfileImage:String = ""
}

struct Response:Decodable {
    var results:[Photos]?
}

struct Photos:Decodable {
    var alt_description:String?
    var urls:Urls?
    var user:User?
    
}

struct Urls:Decodable {
    var thumb:String?
    var regular:String?
    var small:String?
}

struct User:Decodable {
    var name:String?
    var profile_image:Urls
}
