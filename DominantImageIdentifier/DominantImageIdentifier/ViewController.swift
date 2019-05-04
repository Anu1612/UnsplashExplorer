//
//  ViewController.swift
//  DominantImageIdentifier
//
//  Created by anurag ojha on 28/04/19.
//  Copyright © 2019 anuragojha. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var selectedIndex:Int?
    var images: [UnsplashImage]?
    var fullresolutions = [String]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count: \(images?.count ?? 0)")
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        let imageUrl = URL(string:images![indexPath.item].thumbImage)
            do {
                let data = try Data(contentsOf: imageUrl!)
                cell.imageThumb.image = UIImage(data: data)
                
            } catch{
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItem Called and Index:",indexPath.item)
        self.selectedIndex = indexPath.item
        DispatchQueue.main.async {
            self.performSegue(withIdentifier:"loadImage", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        self.images = [UnsplashImage]()
        NetworkRequest.getImages { (responsejson) in
            let responseArray = (responsejson as! NSDictionary) ["results"]
            for Aresponse in (responseArray as! NSArray){
                let image = UnsplashImage()
                image.thumbImage = (((Aresponse as! NSDictionary)["urls"]) as! NSDictionary)["small"] as! String
                image.fullResolutionImage = (((Aresponse as! NSDictionary)["urls"]) as! NSDictionary)["full"] as! String
                self.images?.append(image)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let imageVc = segue.destination as? SelectedImage else {
            return
        }
        imageVc.image = self.images![self.selectedIndex!]
        
    }
}

