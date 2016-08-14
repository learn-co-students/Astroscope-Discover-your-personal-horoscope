//
//  DatePickerViewController.swift
//  Lemonade
//
//  Created by Susan Zheng on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController
{
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var startDate : NSDate!
    var userBirthday : NSDate!
    var horoscopeString : String = ""
    var dateInNumerics : Int = 0
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    //Gets user's input from date picker
    @IBAction func datePickerAction(sender: AnyObject)
    {
        //starting date (January 01)
        let startDateString = "January-01"
        
        let startStringFormatter = NSDateFormatter()
        startStringFormatter.dateFormat = "MMMM-dd"
        self.startDate = startStringFormatter.dateFromString(startDateString)
        print("Start Date : \(self.startDate)")
        
        //User's input for their birthday
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM-dd"
        let userBirthday = dateFormatter.stringFromDate(datePicker.date)
        
        let birthdayFormatDate = NSDateFormatter()
        birthdayFormatDate.dateFormat = "MMMM-dd"
        self.userBirthday = birthdayFormatDate.dateFromString(userBirthday)
        print("User's Input: \(self.userBirthday)")
    

        daysBetweenDates(self.startDate, endDate: self.userBirthday)
        gettingHoroscopeString(dateInNumerics)
        
    }
    
    //Function that takes the difference between startDate and user's birthday
    func daysBetweenDates(startDate: NSDate, endDate: NSDate) -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Day], fromDate: startDate, toDate: endDate, options: [])
        
        self.dateInNumerics = components.day
        return dateInNumerics
    }
    
    //Function that determines what horoscope they are based on where their birthday fall within range
    func gettingHoroscopeString(date: Int)->String
    {
        if self.dateInNumerics >= 0 && self.dateInNumerics <= 19
        {
            self.horoscopeString = "Capricorn"
        }
        else if self.dateInNumerics >= 20 && self.dateInNumerics <= 49
        {
            self.horoscopeString = "Aquarius"
        }
        else if self.dateInNumerics >= 50 && self.dateInNumerics <= 79
        {
            self.horoscopeString = "Pisces"
        }
        if self.dateInNumerics >= 80 && self.dateInNumerics <= 109
        {
            self.horoscopeString = "Aries"
        }
        else if self.dateInNumerics >= 110 && self.dateInNumerics <= 140
        {
            self.horoscopeString = "Taurus"
        }
        else if self.dateInNumerics >= 141 && self.dateInNumerics <= 171
        {
            self.horoscopeString = "Gemini"
        }
        else if self.dateInNumerics >= 172 && self.dateInNumerics <= 203
        {
            self.horoscopeString = "Cancer"
        }
        else if self.dateInNumerics >= 204 && self.dateInNumerics <= 234
        {
            self.horoscopeString = "Leo"
        }
        else if self.dateInNumerics >= 235 && self.dateInNumerics <= 265
        {
            self.horoscopeString = "Virgo"
        }
        else if self.dateInNumerics >= 266 && self.dateInNumerics <= 295
        {
            self.horoscopeString = "Libra"
        }
        else if self.dateInNumerics >= 296 && self.dateInNumerics <= 325
        {
            self.horoscopeString = "Scorpio"
        }
        else if self.dateInNumerics >= 326 && self.dateInNumerics <= 355
        {
            self.horoscopeString = "Sagittarius"
        }
        else if self.dateInNumerics >= 356 && self.dateInNumerics <= 365
        {
            self.horoscopeString = "Capricorn"
        }
        
        return self.horoscopeString
    }
    
    //just a button that segues
    @IBAction func submitButton(sender: AnyObject)
    {
        print(dateInNumerics)
        print(horoscopeString)
    }

    
    // MARK: - Navigation
    //Segues to HoroscopeViewController and passes string 'horoscopeString' to destination
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        var destinationVC = segue.destinationViewController as? HoroscopeViewController
        
        //destinationVC.'whatever property you have as type String' = horoscopeString
        
    }
    

}
