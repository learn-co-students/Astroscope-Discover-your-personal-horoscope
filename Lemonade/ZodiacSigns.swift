//
//  ZodiacSigns.swift
//  Lemonade
//
//  Created by Bettina on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
//var zodiacSign : String()
//secrets? variable for sun sign

// values can be an array, may have to structure data from datePicker
//generate sign dictionary within a different class so not living in viewController with generateDictionary() or maybe dataStore calls date argument to figure out sign and return sign to get horoscope


// Aries March 21- April 19

// Taurus April 20 - May 20

//  Gemini   May 21 - June 20

//  Cancer June 21 - july 22

//  Leo July 23 - August 22

//  Virgo august 23- september 22

//  Libra september 23 - october 22

//  Scorpio october 23 - november 21

//  Sagittarius November 22 - December 21

//  Capricorn December 22 - January 19

//  Aquarius January 20 - February 18

//  Pisces February 19 - March 20

class ZodiacSigns {
    
    
    var startDate : NSDate!
    var userBirthday : NSDate!
    var horoscopeString : String = ""
    var dateInNumerics : Int = 0
    
class func getZodiacSign(month: String , day: Int) -> String {
    
    var sunSign = ""
    
    if month == "March" && day <= 20  {
        sunSign = "Pisces"
    } else if month == "March" && 20 < day {
        sunSign = "Aries"
    } else if month == "April" && day <= 19  {
        sunSign = "Aries"
    } else if month == "April" && 19 < day {
        sunSign = "Taurus"
    }
    
    return sunSign
 }

//  
//    
//
//    func daysBetweenDates(startDate: NSDate, endDate: NSDate) -> Int
//    {
//        let calendar = NSCalendar.currentCalendar()
//        
//        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
//        
//        self.dateInNumerics = components.day
//        return dateInNumerics
//    }
//    
//    //Function that determines what horoscope they are based on where their birthday fall within range
//   
//    func gettingHoroscopeString(date: Int)->String
//    {
//        if self.dateInNumerics >= 0 && self.dateInNumerics <= 19
//        {
//            self.horoscopeString = "Capricorn"
//        }
//        else if self.dateInNumerics >= 20 && self.dateInNumerics <= 49
//        {
//            self.horoscopeString = "Aquarius"
//        }
//        else if self.dateInNumerics >= 50 && self.dateInNumerics <= 79
//        {
//            self.horoscopeString = "Pisces"
//        }
//        else if self.dateInNumerics >= 80 && self.dateInNumerics <= 109
//        {
//            self.horoscopeString = "Aries"
//        }
//        else if self.dateInNumerics >= 110 && self.dateInNumerics <= 140
//        {
//            self.horoscopeString = "Taurus"
//        }
//        else if self.dateInNumerics >= 141 && self.dateInNumerics <= 171
//        {
//            self.horoscopeString = "Gemini"
//        }
//        else if self.dateInNumerics >= 172 && self.dateInNumerics <= 203
//        {
//            self.horoscopeString = "Cancer"
//        }
//        else if self.dateInNumerics >= 204 && self.dateInNumerics <= 234
//        {
//            self.horoscopeString = "Leo"
//        }
//        else if self.dateInNumerics >= 235 && self.dateInNumerics <= 265
//        {
//            self.horoscopeString = "Virgo"
//        }
//        else if self.dateInNumerics >= 266 && self.dateInNumerics <= 295
//        {
//            self.horoscopeString = "Libra"
//        }
//        else if self.dateInNumerics >= 296 && self.dateInNumerics <= 325
//        {
//            self.horoscopeString = "Scorpio"
//        }
//        else if self.dateInNumerics >= 326 && self.dateInNumerics <= 355
//        {
//            self.horoscopeString = "Sagittarius"
//        }
//        else if self.dateInNumerics >= 356 && self.dateInNumerics <= 365
//        {
//            self.horoscopeString = "Capricorn"
//        }
//        
//        return self.horoscopeString
//    }
//
////take string sunSign and use as key in zodiacTodayDictionary
}