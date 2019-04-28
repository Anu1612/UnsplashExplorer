//
//  ViewController.swift
//  DominantImageIdentifier
//
//  Created by sonalojha on 28/04/19.
//  Copyright © 2019 anuragojha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var unsplashImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        NetworkRequest.getImages {
            print("completed")
        }
        
    }


    @IBAction func loadImagefromUrl(_ sender: Any) {
        let imageUrl = URL(string: "https://images.unsplash.com/photo-1519058497187-7167f17c6daf?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=400&fit=max&ixid=eyJhcHBfaWQiOjY4ODAwfQ")
        do {
            let data = try Data(contentsOf: imageUrl!)
            self.unsplashImage.image = UIImage(data: data)
            
        } catch{
        }
    }
}

