//
//  NASAAPI.swift
//  Lemonade
//
//  Created by Bettina on 8/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit

class NASA_API_Client {
    
    class func getPhotoOfDay(_ completion: @escaping (UIImage) -> ()) {
        
        
        let dictionaryURLString = "https://api.nasa.gov/planetary/apod?api_key=\(Secrets.keyNASAAPI)"
        
        let dictionaryURL = URL(string: dictionaryURLString)
        
        let dictionarySession = URLSession.shared
        
        
        guard let unwrappedDictionaryURL = dictionaryURL else { return }
        
        
        let iRequest = URLRequest(url: unwrappedDictionaryURL)
        let request = NSMutableURLRequest.init(url: unwrappedDictionaryURL)
        
        request.httpMethod = "GET"
        
        let task = dictionarySession.dataTask(with: iRequest, completionHandler: { (data, response, error) in
            
            guard let unwrappedData = data else {return}
            
            do {
                guard let photoDictionary = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary else {return}
                
                
                print(photoDictionary)
                
                guard let imageURLString = photoDictionary["url"] as? String else {return}
                guard let imageURL = URL(string: imageURLString) else {return}
                let imageRequest = NSMutableURLRequest.init(url: imageURL)
                
                imageRequest.httpMethod = "GET"
                
                let imageDataTask = dictionarySession.dataTask(with: imageURL, completionHandler: { (photoData, photoResponse, photoError) in
                    
                    guard let photoOfDay = photoData else {return}
                    guard let photo = UIImage(data: photoOfDay) else {return}
                    
                    completion(photo)
                    
                }) 
                
                imageDataTask.resume()
                
            } catch {
                print(error)
                
            }
            
        })
        
        task.resume()
        
    }
    
    class func getMediaType(_ completion: @escaping (String)->())
    {
      
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(Secrets.keyNASAAPI)"
        
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            guard let unwrappedData = data else {return}
            
            do{
                let mediaType = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                
                let media = mediaType["media_type"] as? String
                
                guard let unwrappedMediaType = media else {return}
                
                completion(unwrappedMediaType)
                
            }
            catch{
                print(error)
            }
        }) 
        dataTask.resume()
    
    }

    class func getNASAPhotoInfo(_ completion: @escaping (NSDictionary)->())
    {
        
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(Secrets.keyNASAAPI)"
        
        let url = URL(string: urlString)
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            guard let unwrappedData = data else {return}
            
            do{
                let info = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
             
                completion(info)
                
            }
            catch{
                print(error)
            }
        })
        dataTask.resume()
        
    }
}
