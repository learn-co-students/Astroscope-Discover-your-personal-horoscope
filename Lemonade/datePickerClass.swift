//
//  datePickerClass.swift
//  Lemonade
//
//  Created by Susan Zheng on 8/15/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation

class datePickerClass
{
    
    //Function that takes the difference between startDate and user's birthday
    func daysBetweenDates(startDate: NSDate, endDate: NSDate) -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        
        return components.day
    }

    
    //Function that determines what horoscope they are based on where their birthday fall within range
    func gettingHoroscopeString(date: Int)->String
    {
        
        var horoscopeString : String = ""
        
        if date >= 0 && date <= 19
        {
            horoscopeString = "Capricorn"
        }
        else if date >= 20 && date <= 49
        {
            horoscopeString = "Aquarius"
        }
        else if date >= 50 && date <= 79
        {
            horoscopeString = "Pisces"
        }
        else if date >= 80 && date <= 109
        {
            horoscopeString = "Aries"
        }
        else if date >= 110 && date <= 140
        {
            horoscopeString = "Taurus"
        }
        else if date >= 141 && date <= 171
        {
            horoscopeString = "Gemini"
        }
        else if date >= 172 && date <= 203
        {
            horoscopeString = "Cancer"
        }
        else if date >= 204 && date <= 234
        {
            horoscopeString = "Leo"
        }
        else if date >= 235 && date <= 265
        {
            horoscopeString = "Virgo"
        }
        else if date >= 266 && date <= 295
        {
            horoscopeString = "Libra"
        }
        else if date >= 296 && date <= 325
        {
            horoscopeString = "Scorpio"
        }
        else if date >= 326 && date <= 355
        {
            horoscopeString = "Sagittarius"
        }
        else if date >= 356 && date <= 365
        {
            horoscopeString = "Capricorn"
        }
        
        return horoscopeString
    }
    
    
    func passingTheHoroscope(startDate: NSDate, endDate: NSDate)->String
    {
        let difference = daysBetweenDates(startDate, endDate: endDate)
        let horoscopeFromDate = gettingHoroscopeString(difference)
        
        return horoscopeFromDate
    }

}
