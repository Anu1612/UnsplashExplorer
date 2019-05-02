//
//  ViewController.swift
//  DominantImageIdentifier
//
//  Created by anurag ojha on 28/04/19.
//  Copyright © 2019 anuragojha. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var fullResolutionIndex:Int?
    var items = [String]()
    var fullresolutions = [String]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count: \(self.items.count)")
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
            let imageUrl = URL(string:items[indexPath.item])
            do {
                let data = try Data(contentsOf: imageUrl!)
                cell.imageThumb.image = UIImage(data: data)
                
            } catch{
            }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItem Called and Index:",indexPath.item)
        self.fullResolutionIndex = indexPath.item
        self.performSegue(withIdentifier:"loadImage", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        NetworkRequest.getImages { (responsejson) in
            let responseArray = (responsejson as! NSDictionary) ["results"]
            for Aresponse in (responseArray as! NSArray){
                self.items.append((((Aresponse as! NSDictionary)["urls"]) as! NSDictionary)["small"] as! String)
                self.fullresolutions.append((((Aresponse as! NSDictionary)["urls"]) as! NSDictionary)["full"] as! String)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let imageVc = segue.destination as? SelectedImage else {
            return
        }
        print(self.fullResolutionIndex)
        if let index = self.fullResolutionIndex {
            imageVc.imageUrl = fullresolutions[index]
        }
    }
}

