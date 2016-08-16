//
//  DatePickerViewController.swift
//  Lemonade
//
//  Created by Susan Zheng on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData


class DatePickerViewController: UIViewController {
    
    let store = DataStore()
    var birthdayFromStore: Int32?


    @IBOutlet weak var datePicker: UIDatePicker!
    
    var startDate : NSDate!
    var userBirthday : NSDate!
    
    var dateClass = datePickerClass()
    
    @IBOutlet weak var selectBirthdayLabel: UILabel!
    //For testing purposes
    override func viewDidLoad()
    {

        super.viewDidLoad()

//         test datastore fetch function - input in date picker
//        store.fetchData()
//        birthdayFromStore = store.individual?.birthdate
//        print(birthdayFromStore)
        
        // Do any additional setup after loading the view.

        
//        datePickerAction("")
//        
//        print(startDate)
//        print(userBirthday)
//    
//        print(dateClass.gettingHoroscopeString(80))
        
        self.view.backgroundColor = UIColor.blackColor()
        self.datePicker.backgroundColor = UIColor.clearColor()
        self.datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        self.datePicker.setValue(false, forKey: "highlightsToday")



    }
    
    
    func generateData () {
        
    }
    

    //Gets user's input from date picker
    @IBAction func datePickerAction(sender: AnyObject)
    {
        //starting date (January 01)
        let startDateString = "January-01"
        
        let startStringFormatter = NSDateFormatter()
        startStringFormatter.dateFormat = "MMMM-dd"
        self.startDate = startStringFormatter.dateFromString(startDateString)
      
        
        //User's input for their birthday
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM-dd"
        let userBirthday = dateFormatter.stringFromDate(datePicker.date)
        
        let birthdayFormatDate = NSDateFormatter()
        birthdayFormatDate.dateFormat = "MMMM-dd"
        self.userBirthday = birthdayFormatDate.dateFromString(userBirthday)
        //print("User's Input: \(self.userBirthday)")

    }
    
    
    //just a button that prints
    @IBAction func submitButton(sender: AnyObject)
    {
        //let horo = dateClass.passingTheHoroscope(startDate, endDate: userBirthday)
        //print("After using datepicker: \(horo)")
    }
 
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let destinationVC = segue.destinationViewController as? HoroscopeViewController
        
        let horoToBeSegued = dateClass.passingTheHoroscope(startDate, endDate: userBirthday)

        destinationVC?.passedHoroscopeString = horoToBeSegued
    }

 

}
