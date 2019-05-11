//
//  NetworkRequest.swift
//  DominantImageIdentifier
//
//  Created by Anurag Ojha on 28/04/19.
//  Copyright © 2019 anuragojha. All rights reserved.
//

import Foundation

class NetworkRequest {
    static func getImages(search:String,pageNo:String,completionHandler: @escaping (Any)->()){
        print("Network Request started")
        let client_id = "40759028c23019bbd0a4364f69902e20ad71e141cb9342fc0eb323a4be879cb4"
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "api.unsplash.com"
        urlComponent.path = "/search/photos"
        urlComponent.queryItems = [
            URLQueryItem(name: "client_id", value: client_id),
            URLQueryItem(name: "query", value: search),
            URLQueryItem(name: "page", value: pageNo),
            URLQueryItem(name: "per_page", value: "10")
        ]
        let splashRequest = URLRequest(url: urlComponent.url!)
        
        let dataTask = URLSession.shared.dataTask(with: splashRequest) { (data, response, error) in
            if ((response as! HTTPURLResponse).statusCode == 200){
                if let data = data{
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                        print("Server Response: \(jsonResponse)")
                        print("response Succesfully received")
                        let responses = try JSONDecoder().decode(Response.self, from: data)
                        completionHandler(responses)
                    }catch let error{
                        print(error.localizedDescription)
                    }
                }
            }
            else if((response as! HTTPURLResponse).statusCode == 403){
                print("Eighter end of content or Not found")
            }
            else{
                print(error?.localizedDescription)
            }
        }
        dataTask.resume()
        
    }
}
