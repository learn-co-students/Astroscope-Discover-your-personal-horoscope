//
//  HoroscopeAPIClient.swift
//  Lemonade
//
//  Created by Bettina on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class HoroscopeAPIClient {
    
    
//    class func getDailyHoroscope(sign: String, completion: NSDictionary ->()) {
//        
//        
//        let urlString = "https://horoscope-api.herokuapp.com/horoscope/today/\(sign)"
//        
//        let url = NSURL(string: urlString)
//        
//        let session = NSURLSession.sharedSession()
//        
//        
//        guard let unwrappedURL = url else { return }
//        
//        
//        let dataTask = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
//            
//            guard let unwrappedData = data else {return}
//            
//            do {
//                let zodiacTodayDictionary = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
//                
//                
//                guard let unwrappedZodiac = zodiacTodayDictionary else {return}
//                completion(unwrappedZodiac)
//                
//            } catch {
//                print(error)
//            }
//            
//        }
//        
//        
//        dataTask.resume()
//        
//    }

//    
    
    class func getAnyDayHoroscope(sign: String, day: String, completion: NSDictionary ->()) {
    
    
            let urlString = "https://theastrologer-api.herokuapp.com/api/horoscope/\(sign)/\(day)"
    
            let url = NSURL(string: urlString)
    
            let session = NSURLSession.sharedSession()
    
    
            guard let unwrappedURL = url else { return }
    
    
            let dataTask = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
    
                guard let unwrappedData = data else {return}
    
                do {
                    let zodiacTodayDictionary = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
    
    
                    guard let unwrappedZodiac = zodiacTodayDictionary else {return}
                    completion(unwrappedZodiac)
    
                } catch {
                    print(error)
                }
              }
            
            dataTask.resume()
            
        }
    
        


    class func getYesterdaysHoroscope(sign: String, completion: NSDictionary ->()) {
        
        
        let urlString = "https://theastrologer-api.herokuapp.com/api/horoscope/\(sign)/yesterday"
        
        let url = NSURL(string: urlString)
        
        let session = NSURLSession.sharedSession()
        
        
        guard let unwrappedURL = url else { return }
        
        
        let dataTask = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            
            guard let unwrappedData = data else {return}
            
            do {
                let zodiacTodayDictionary = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                
                guard let unwrappedZodiac = zodiacTodayDictionary else {return}
                completion(unwrappedZodiac)
                
            } catch {
                print(error)
            }
          }
        
        dataTask.resume()
        
    }

    
    class func getTodaysHoroscope(sign: String, completion: NSDictionary ->()) {
        
        
        let urlString = "https://theastrologer-api.herokuapp.com/api/horoscope/\(sign)/today"
        
        let url = NSURL(string: urlString)
        
        let session = NSURLSession.sharedSession()
        
        
        guard let unwrappedURL = url else { return }
        
        
        let dataTask = session.dataTaskWithURL(unwrappedURL) { (data, response, error) in
            
            guard let unwrappedData = data else {return}
            
            do {
                let zodiacTodayDictionary = try NSJSONSerialization.JSONObjectWithData(unwrappedData, options: NSJSONReadingOptions.AllowFragments) as? NSDictionary
                
                
                guard let unwrappedZodiac = zodiacTodayDictionary else {return}
                completion(unwrappedZodiac)
                
            } catch {
                print(error)
            }
        }
        
        dataTask.resume()
        
    }

}