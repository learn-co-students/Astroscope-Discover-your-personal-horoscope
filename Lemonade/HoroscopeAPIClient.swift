//
//  HoroscopeAPIClient.swift
//  Lemonade
//
//  Created by Bettina on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class HoroscopeAPIClient {
      
    
    class func getAnyDayHoroscope(_ sign: String, day: String, completion: @escaping (NSDictionary) ->()) {
    
    
            let urlString = "https://theastrologer-api.herokuapp.com/api/horoscope/\(sign)/\(day)"
    
            let url = URL(string: urlString)
    
            let session = URLSession.shared
    
    
            guard let unwrappedURL = url else { return }
    
    
            let dataTask = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
    
                guard let unwrappedData = data else {return}
    
                do {
                    let zodiacTodayDictionary = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
    
    
                    guard let unwrappedZodiac = zodiacTodayDictionary else {return}
                    completion(unwrappedZodiac)
    
                } catch {
                    print(error)
                }
              }) 
            
            dataTask.resume()
            
        }
    
        
}
