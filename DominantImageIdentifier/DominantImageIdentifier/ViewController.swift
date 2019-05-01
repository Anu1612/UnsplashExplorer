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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count: \(self.items.count)")
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("called")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        if !((indexPath.item)>items.count){
            let imageUrl = URL(string:items[indexPath.item+1])
            do {
                let data = try Data(contentsOf: imageUrl!)
                cell.imageThumb.image = UIImage(data: data)
                
            } catch{
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItem Called and Index:",indexPath.item)
        self.fullResolutionIndex = indexPath.item+1
        self.performSegue(withIdentifier:"loadImage", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewDidLoad")
        NetworkRequest.getImages { (responsejson) in
            let responseArray = (responsejson as! NSDictionary) ["results"]
            for Aresponse in (responseArray as! NSArray){
                print((((Aresponse as! NSDictionary)["urls"]) as! NSDictionary)["small"])
                self.items.append((((Aresponse as! NSDictionary)["urls"]) as! NSDictionary)["thumb"] as! String)
                self.items.append((((Aresponse as! NSDictionary)["urls"]) as! NSDictionary)["full"] as! String)
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let imageVc = segue.destination as? SelectedImage else {
            return
        }
        print(self.fullResolutionIndex)
        if let index = self.fullResolutionIndex {
            imageVc.imageUrl = items[index]
        }
    }
}

