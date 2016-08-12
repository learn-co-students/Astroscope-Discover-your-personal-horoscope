//
//  NASAAPIClient.swift
//  Lemonade
//
//  Created by Bettina on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class NASA_API_Client {
    
    class func getPhotoOfDay(completion: UIImage -> ()) {
        //argument to function call image into microfunction
        
        
        //        Alamofire.request(.GET, "https://api.nasa.gov/planetary/apod?api_key=teLJU5iqcev3znTAu89eZl66XVsphq7dNNDtdR36")
        //
        //
        //            .responseJSON { response in
        //                print(response.request)  // original URL request
        //                print(response.response) // URL response
        //                print(response.data)     // server data
        //                print(response.result)   // result of response serialization
        //
        //                if let JSON = response.result.value {
        //                    print("JSON: \(JSON)")
        //                }
        //        }
        
        //repsonse is a tuple and we're unwrapping it and doing things to it.
        // .result us a tuple itself (value, error)
        //   JSON is declared as a struct within swiftyJSON
        
        //        Alamofire.download(.GET, url) { temporaryURL, response in
        //            let fileManager = NSFileManager.defaultManager()
        //            let directoryURL = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        //            let pathComponent = response.suggestedFilename
        //
        //            return directoryURL.URLByAppendingPathComponent(pathComponent!)
        //        }
        
        
        
        
        //temporarily download image from internet to your phone using Alamofire
        Alamofire.request(.GET, "https://api.nasa.gov/planetary/apod?api_key=\(Secrets.key)").validate().responseJSON { response in
            print("THIS IS THE FIRST ALAMOFIRE FUNCTION")
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    print("JSON: \(json)")
                    let imageURL = json["url"].stringValue
                    print("image URL:\(imageURL)")
                    
                    Alamofire.request(.GET, imageURL)
                        .responseImage { response in
                            
                            debugPrint(response)
                            
                            print(response.request)
                            print(response.response)
                            debugPrint(response.result)
                            
                            if let image = response.result.value {
                                print("image downloaded: \(image)")
                                completion(image)
                                
                            }
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
        
        
    }
    
}