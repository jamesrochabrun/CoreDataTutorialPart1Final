//
//  APIservice.swift
//  CoreDataTutorialPart1Final
//
//  Created by James Rochabrun on 3/2/17.
//  Copyright © 2017 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class APIService: NSObject {
    
    let query = "apps"
    lazy var endPoint: String = {
        return "https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=\(self.query)&nojsoncallback=1#"
    }()
    
    func getDataWith(success: @escaping ((_ jsonArray:[[String: AnyObject]]) -> Void), failure: @escaping (() -> Void)) {
        
        let urlString = endPoint
        
        guard let url = URL(string: urlString) else {
            print("ERROR IN URL STRUCTURE")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("ERROR FETCHING JSON: ", error ?? "error")
                DispatchQueue.main.async {
                    failure()
                }
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: [.mutableContainers]) as? [String: AnyObject] {
                    guard let itemsJsonArray = json["items"] as? [[String: AnyObject]] else {
                        print("ERROR IN JSON STRUCTURE FROM THE SERVER")
                        return
                    }
                    DispatchQueue.main.async {
                        success(itemsJsonArray)
                    }
                }
            } catch let error {
                print("SERIALIZATION ERROR PROBABLY DATA STRUCTURE FROM SERVER:" , error)
            }
            }.resume()
    }
    
    
    
    
    
    
    
    
}
