//
//  SelectedImage.swift
//  DominantImageIdentifier
//
//  Created by anurag ojha on 02/05/19.
//  Copyright © 2019 anuragojha. All rights reserved.
//

import Foundation
import UIKit
import CoreML

class SelectedImage: UIViewController {
    var image:UnsplashImage?
    
    
    let model = Resnet50()
    lazy var imageCache = NSCache<AnyObject, AnyObject>()
    
    @IBOutlet weak var loadingImageIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fullresolution: UIImageView!
    @IBOutlet weak var userProfile: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        loadingImageIndicator.startAnimating()
        userName.text = image?.user
        DispatchQueue.global().async { [weak self] in
            if let profileUrl = self?.image?.userProfileImage{
                do{
                    let data = try Data(contentsOf: URL(string: profileUrl)!)
                    DispatchQueue.main.async {
                        self?.userProfile.image = UIImage(data: data)
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        DispatchQueue.global().async { [weak self] in
            if let url = self?.image?.fullResolutionImageUrl{
                let imageUrl = URL(string:url)
                do {
                    let data = try Data(contentsOf: imageUrl!)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self?.loadingImageIndicator.stopAnimating()
                        self?.loadingImageIndicator.isHidden = true
                        self?.fullresolution.image = image!
                    }
                } catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func PredictObject(_ sender: Any) {
        if let image = self.fullresolution.image{
            DispatchQueue.global().async {
                print(self.predictDominantObject(image: image))
            }
        }
        else{
            fatalError("Unable to Load Images")
        }
    }
    func predictDominantObject(image:UIImage) -> String? {
        if let pixelBuffer = ImageProcessor.pixelBuffer(forImage: image.cgImage!,height: 224,width: 224){
            guard let prediction = try? model.prediction(image: pixelBuffer)
                else {
                    fatalError("Unable to Process Image")
            }
            return prediction.classLabel
        }
        return nil
    }
    
}
