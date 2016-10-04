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
    
    class func getPhotoOfDay(completion: UIImage -> ()) {
        
        
        let dictionaryURLString = "https://api.nasa.gov/planetary/apod?api_key=\(Secrets.keyNASAAPI)"
        
        let dictionaryURL = NSURL(string: dictionaryURLString)
        
        let dictionarySession = NSURLSession.sharedSession()
        
        
        guard let unwrappedDictionaryURL = dictionaryURL else { return }
        
        
        let request = NSMutableURLRequest.init(URL: unwrappedDictionaryURL)
        
        request.HTTPMethod = "GET"
        
        let task = dictionarySession.dataTaskWithRequest(request){ (data, response, error) in
            
            
            guard let unwrappedData = data else {return}
            
            do {
                guard let photoDictionary = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary else {return}
                
                
                print(photoDictionary)
                
                guard let imageURLString = photoDictionary["url"] as? String else {return}
                guard let imageURL = NSURL(string: imageURLString) else {return}
                let imageRequest = NSMutableURLRequest.init(URL: imageURL)
                
                imageRequest.HTTPMethod = "GET"
                
                let imageDataTask = dictionarySession.dataTaskWithURL(imageURL) { (photoData, photoResponse, photoError) in
                    
                    guard let photoOfDay = photoData else {return}
                    guard let photo = UIImage(data: photoOfDay) else {return}
                    
                    completion(photo)
                    
                }
                
                imageDataTask.resume()
                
            } catch {
                print(error)
                
            }
            
        }
        
        task.resume()
        
    }
    
    class func getMediaType(completion: String->())
    {
      
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(Secrets.keyNASAAPI)"
        
        let url = NSURL(string: urlString)
        
        let session = NSURLSession.sharedSession()
        
        let dataTask = session.dataTaskWithURL(url!) { (data, response, error) in
            guard let unwrappedData = data else {return}
            
            do{
                let mediaType = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.AllowFragments)
                
                let media = mediaType["media_type"] as? String
                
                guard let unwrappedMediaType = media else {return}
                
                completion(unwrappedMediaType)
                
            }
            catch{
                print(error)
            }
        }
        dataTask.resume()
    
    }

}
