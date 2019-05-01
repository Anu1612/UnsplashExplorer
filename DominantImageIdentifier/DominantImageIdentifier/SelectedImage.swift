//
//  SelectedImage.swift
//  DominantImageIdentifier
//
//  Created by anurag ojha on 02/05/19.
//  Copyright © 2019 anuragojha. All rights reserved.
//

import Foundation
import UIKit

class SelectedImage: UIViewController {
    var imageUrl:String?
    
    @IBOutlet weak var fullresolution: UIImageView!
    
    override func viewDidLoad() {
        if let url = imageUrl{
            let imageUrl = URL(string:url)
            do {
                let data = try Data(contentsOf: imageUrl!)
                self.fullresolution.image = UIImage(data: data)
            
            } catch{
            }
        }
    }
    
}
