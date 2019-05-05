//
//  ViewController.swift
//  DominantImageIdentifier
//
//  Created by anurag ojha on 28/04/19.
//  Copyright © 2019 anuragojha. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PinterestLayoutDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var searchUnsplash: UITextField!
    @IBOutlet weak var feedCollectionView: UICollectionView!
    var selectedIndex:Int?
    var images: [UnsplashImage]?
    var fullresolutions = [String]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count: \(images?.count ?? 0)")
        return images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        if let image = images?[indexPath.item]{
            DispatchQueue.main.async {
                cell.imageThumb.image = image.thumbImage
            }
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
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        print("\(#function) called")
        guard let height = images?[indexPath.item].thumbImage.size.height else{
            return 0
        }
        print("height of image: \(height) at index \(indexPath.item)")
        return height
    }
    
    override func viewDidLoad() {
        self.activityIndicator.isHidden = true
        super.viewDidLoad()
        if let layout = feedCollectionView?.collectionViewLayout as? PinterestLayout {
            print("")
            layout.delegate = self
        }
        else{
            print("Inside Laytout")
        }
        print("ViewDidLoad")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("\(#function) called")
    }
    
    @IBAction func SearchUnsplash(_ sender: Any) {
        print("called")
        guard let search = self.searchUnsplash?.text?.trimmingCharacters(in:.whitespaces) else{
            print("else called")
            self.searchUnsplash.placeholder = "something needed"
            return
        }
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        self.images = [UnsplashImage]()
        NetworkRequest.getImages(search: search, completionHandler:{ (responsejson) in
            let responseArray = (responsejson as! NSDictionary) ["results"]
            for Aresponse in (responseArray as! NSArray){
                let image = UnsplashImage()
                image.thumbImageUrl = (((Aresponse as! NSDictionary)["urls"]) as! NSDictionary)["thumb"] as! String
                image.fullResolutionImageUrl = (((Aresponse as! NSDictionary)["urls"]) as! NSDictionary)["regular"] as! String
                let imageUrl = URL(string:image.thumbImageUrl)
                do {
                    let data = try Data(contentsOf: imageUrl!)
                    image.thumbImage = UIImage(data: data)!
                    
                }catch{
                }
                self.images?.append(image)
            }
            DispatchQueue.main.async {
                self.feedCollectionView.reloadData()
            }
            
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let imageVc = segue.destination as? SelectedImage else {
            return
        }
        imageVc.image = self.images![self.selectedIndex!]
        
    }
}
