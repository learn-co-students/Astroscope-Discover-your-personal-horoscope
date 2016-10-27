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
    
            let request = NSMutableURLRequest(url: unwrappedURL)
        
            request.httpMethod = "GET"
        
        
    
            let dataTask = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
    
                guard let unwrappedData = data else {return}
                guard let responseValue = response as? HTTPURLResponse else {return}
                
                
                if responseValue.statusCode == 503
                {
                    print("\(responseValue.statusCode): original API not working, gotta use ganesia")
                    
                    let urlString = "https://horoscope-api.herokuapp.com/horoscope/today/\(sign)"
                    
                    let session = URLSession.shared
                    
                    let url = URL(string: urlString)
                    
                    guard let URL = url else { return }
                    
                    
                    let Task = session.dataTask(with: URL, completionHandler: { (data, response, error) in
                        
                        guard let unwrappedData = data else {return}
                        
                        
                        do {
                            let TodayDictionary = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
                            
                            
                            guard let Zodiac = TodayDictionary else {return}
                            completion(Zodiac)
                            
                        } catch {
                            print(error)
                        }
                    
                    })
                    Task.resume()
                    
                }
                else
                {
                    print("Original API Working")
                    
                    do {
                    let zodiacTodayDictionary = try JSONSerialization.jsonObject(with: unwrappedData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary
    
    
                    guard let unwrappedZodiac = zodiacTodayDictionary else {return}
                    completion(unwrappedZodiac)
    
                } catch {
                    print(error)
                }
                }
                
              }) 
            
            dataTask.resume()
            
        }
    
    
}
