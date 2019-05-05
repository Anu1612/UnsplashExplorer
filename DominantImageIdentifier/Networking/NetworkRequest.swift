//
//  NetworkRequest.swift
//  DominantImageIdentifier
//
//  Created by Anurag Ojha on 28/04/19.
//  Copyright © 2019 anuragojha. All rights reserved.
//

import Foundation

class NetworkRequest {
    static func getImages(search:String,completionHandler: @escaping (Any)->()){
        let client_id = ""
        print("entered")
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.unsplash.com"
        urlComponent.path = "/search/photos"
        urlComponent.queryItems = [
            URLQueryItem(name: "client_id", value: client_id),
            URLQueryItem(name: "query", value: search)
        ]
        let splashRequest = URLRequest(url: urlComponent.url!)
        
        let dataTask = URLSession.shared.dataTask(with: splashRequest) { (data, response, error) in
            if ((response as! HTTPURLResponse).statusCode == 200){
                if let data = data{
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options:.mutableContainers)
                        print((jsonResponse as! NSDictionary) ["results"])
                        completionHandler(jsonResponse)
                    }catch let error{
                        print(error.localizedDescription)
                    }
                }
            }
            else{
                print(error?.localizedDescription)
            }
        }
        dataTask.resume()
        
    }
}
