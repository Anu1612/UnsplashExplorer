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
    
    
    let model = GoogLeNetPlaces()
    
    @IBOutlet weak var loadingImageIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fullresolution: UIImageView!
    
    override func viewDidLoad() {
        print("Entered")
        loadingImageIndicator.startAnimating()
        DispatchQueue.global().async { [weak self] in
            if let url = self?.image?.fullResolutionImageUrl{
                let imageUrl = URL(string:url)
                do {
                    let data = try Data(contentsOf: imageUrl!)
                    DispatchQueue.main.async {
                        self?.loadingImageIndicator.stopAnimating()
                        self?.loadingImageIndicator.isHidden = true
                        self?.fullresolution.image = UIImage(data: data)
                    }
                } catch{
                }
            }
        }
    }
    
    @IBAction func PredictObject(_ sender: Any) {
        if let image = self.fullresolution.image{
            print(self.predictDominantObject(image: image))
        }
        else{
            fatalError("Unable to Load Images")
        }
    }
    func predictDominantObject(image:UIImage) -> String? {
        if let pixelBuffer = ImageProcessor.pixelBuffer(forImage: image.cgImage!){
            guard let prediction = try? model.prediction(sceneImage: pixelBuffer)
                else {
                    fatalError("Unable to Process Image")
            }
            return prediction.sceneLabel
        }
        return nil
    }
    
}
