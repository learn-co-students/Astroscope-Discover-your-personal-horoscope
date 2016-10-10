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
    
    //Func that will give a initial start date (January 01)
    func setStartingDate()->Date
    {
        let dateString = "January-01"
        var startingDate : Date!
        
        let startStringFormatter = DateFormatter()
        startStringFormatter.dateFormat = "MMMM-dd"
        let startDate = startStringFormatter.date(from: dateString)
        
        if let unwrappedStartDate = startDate
        {
            startingDate = unwrappedStartDate
        }
        else
        {
            print("not January 01")
        }
        
        return startingDate
        
    }
    
    //Func that will give us the result from user when inputing their bday
    func setEndDate(_ picker: Date)->Date
    {
       
        let defaultEndDate = Date()
        var datePickerEndDate : Date!
        
        var endDateString = ""
        let pickerFormatDate = DateFormatter()
        pickerFormatDate.dateFormat = "MMMM-dd"
        endDateString = pickerFormatDate.string(from: picker)  //taking the value from datePicker
        
        let endDateFormatter = DateFormatter()
        endDateFormatter.dateFormat = "MMMM-dd"
        datePickerEndDate = endDateFormatter.date(from: endDateString)
        
        
        //if the user basically doesn't touch the datePicker, which is already set to "today"
        if datePickerEndDate != datePickerEndDate //if the endDate is not equal to itself
        {
            let formatDate = DateFormatter()
            formatDate.dateFormat = "MMMM-dd"
            let anotherDateString = formatDate.string(from: defaultEndDate)  //taking in "today" date
            
            let endDateFormatter = DateFormatter()
            endDateFormatter.dateFormat = "MMMM-dd"
            let wrappedDate = endDateFormatter.date(from: anotherDateString)
            
            if let unwrapped = wrappedDate
            {
                return unwrapped
            }

        }
        
        return datePickerEndDate
    }
    
    
    func userBirthDayString(_ date: Date)->String
    {
        let format = DateFormatter()
        format.dateFormat = "MMMM dd"
        
        let bdString = format.string(from: date)
        
        return bdString
    }
    
    //Function that takes the difference between startDate and user's birthday
    func daysBetweenDates(_ startDate: Date, endDate: Date) -> Int
    {
        let calendar = Calendar.current
        
        let components = (calendar as NSCalendar).components([.day], from: startDate, to: endDate, options: [])
       
        
        return components.day!
    }

    
    //Function that determines what horoscope they are based on where their birthday fall within range
    func gettingHoroscopeString(_ date: Int)->String
    {
        
        var horoscopeString : String = ""
        
        if date >= 0 && date <= 19
        {
            horoscopeString = "capricorn"
        }
        else if date >= 20 && date <= 49
        {
            horoscopeString = "aquarius"
        }
        else if date >= 50 && date <= 79
        {
            horoscopeString = "pisces"
        }
        else if date >= 80 && date <= 109
        {
            horoscopeString = "aries"
        }
        else if date >= 110 && date <= 140
        {
            horoscopeString = "taurus"
        }
        else if date >= 141 && date <= 171
        {
            horoscopeString = "gemini"
        }
        else if date >= 172 && date <= 203
        {
            horoscopeString = "cancer"
        }
        else if date >= 204 && date <= 234
        {
            horoscopeString = "leo"
        }
        else if date >= 235 && date <= 265
        {
            horoscopeString = "virgo"
        }
        else if date >= 266 && date <= 295
        {
            horoscopeString = "libra"
        }
        else if date >= 296 && date <= 325
        {
            horoscopeString = "scorpio"
        }
        else if date >= 326 && date <= 355
        {
            horoscopeString = "sagittarius"
        }
        else if date >= 356 && date <= 365
        {
            horoscopeString = "capricorn"
        }
        
        return horoscopeString
    }
    
    func setDateForPicker(_ startDate: Date, day: Int)->Date
    {
        var setDate = Date()
        let calendar = (Calendar.current as NSCalendar).date(byAdding: .day, value: day, to: startDate, options: [])
        
        if let unwrappedDate = calendar
        {
            setDate = unwrappedDate
        }
        return setDate
    }

 
    //Func that returns string
    func passingTheHoroscope(_ startDate: Date, endDate: Date)->String
    {
        let difference = daysBetweenDates(startDate, endDate: endDate)
        let horoscopeFromDate = gettingHoroscopeString(difference)
        
        return horoscopeFromDate
    }


}
