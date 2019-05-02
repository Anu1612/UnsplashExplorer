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
    var imageUrl:String?
    var imageThumbUrl:String?
    
    let model = GoogLeNetPlaces()
    
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
    
    @IBAction func PredictObject(_ sender: Any) {
        if let url = imageUrl{
            let imageUrl = URL(string: url)
            do{
                let data = try Data(contentsOf: imageUrl!)
               let predict = self.predictDominantObject(image: UIImage(data:data)!)
                print(predict)
                
            }catch{
            }
            
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
