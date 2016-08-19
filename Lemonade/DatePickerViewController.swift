//
//  DatePickerViewController.swift
//  Lemonade
//
//  Created by Susan Zheng on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData


class DatePickerViewController: UIViewController
{
    
    let store = DataStore.sharedDataStore
    var birthdayFromStore: Int?
    var savedString = ""
    var dateFromPickerString :String?
    
    
    var startDate : NSDate?
    var userBirthday : NSDate?
    
    
    var dateClass = datePickerClass()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectBirthdayLabel: UILabel!
    @IBOutlet weak var bDayLabel: UILabel!
    @IBOutlet weak var submitButtonLabel: UIButton!
    @IBOutlet weak var goToHoroscopeButtonLabel: UIButton!
    @IBOutlet weak var editButtonLabel: UIButton!
    
    
    override func viewDidLoad()
    {

        super.viewDidLoad()
    
        
        let imageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("giphy (3)", withExtension: "gif")!)
        let imageGif = UIImage.gifWithData(imageData!)
        let imageView = UIImageView(image: imageGif)
       
        imageView.frame = self.view.frame
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        
        self.datePicker.backgroundColor = UIColor.clearColor()
        self.datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        self.datePicker.setValue(false, forKey: "highlightsToday")
        
        checkforData()
        
    }
    
    //Checks if theres any data in database when app is open
    func checkforData()
    {
        let context = store.managedObjectContext
        let userRequest = NSFetchRequest(entityName: "Users")
        
        do{
            let object = try context.executeFetchRequest(userRequest) as? [Users]
            
            if object?.count > 0
            {
                if object != nil // if theres data in it
                {
                    selectBirthdayLabel.text = "Welcome back"
                    submitButtonLabel.hidden = true
                    goToHoroscopeButtonLabel.hidden = false
                    editButtonLabel.hidden = false
                    datePicker.hidden = true
                    bDayLabel.hidden = false
                    
                    
                    store.fetchData()
                    
                    let birthDate = store.individual?.birthdate
                    if let unwrappedBirthDate = birthDate
                    {
                        let start = dateClass.setStartingDate()
                        let setDate = (dateClass.setDateForPicker(start, day: Int(unwrappedBirthDate)))
                        
                        self.datePicker.setDate(setDate, animated: true)
                        
                        let meh = dateClass.userBirthDayString(setDate)
                        self.bDayLabel.text = meh
                        
                    }
                    
                }
                
            }
            else if object?.count == 0 // if none
            {
                startDate = dateClass.setStartingDate()
                selectBirthdayLabel.text = "Please select your birthday"
                submitButtonLabel.hidden = false
                goToHoroscopeButtonLabel.hidden = true
                editButtonLabel.hidden = true
                datePicker.hidden = false
                bDayLabel.hidden = true
            
            }
            
        }
        catch
        {
            print(error)
        }
        
    }


    //Gets user's input from date picker
    @IBAction func datePickerAction(sender: AnyObject)
    {
        let startDate = dateClass.setStartingDate()
        let endDate = dateClass.setEndDate(datePicker.date)
        let difference = dateClass.daysBetweenDates(startDate, endDate: endDate)
        
        dateFromPickerString = dateClass.userBirthDayString(datePicker.date)
        
        print("Date picked: \(endDate)")
        print("Julian date: \(difference)")
        print("Date String: \(dateFromPickerString)")
    
    }
    
    
    //Will save the user's input
    @IBAction func submitButton(sender: AnyObject)
    {
        self.submitButtonLabel.hidden = true
        self.selectBirthdayLabel.text = "Welcome Back"
        self.userBirthday = self.dateClass.setEndDate(self.datePicker.date)
        
                
        let context = self.store.managedObjectContext
                
        let person = NSEntityDescription.insertNewObjectForEntityForName(Users.entityName, inManagedObjectContext: context) as! Users
        
        let start = dateClass.setStartingDate()
        let userBday = dateClass.setEndDate(datePicker.date)
        let birthDateInt = Int32(self.dateClass.daysBetweenDates(start, endDate: userBday))
        
        person.birthdate = birthDateInt
                
        store.saveContext()
        print("SubmitButton Pressed")
        print("Horoscope when using datepicker:\(dateClass.gettingHoroscopeString(Int(birthDateInt)))")
                
        self.goToHoroscopeButtonLabel.hidden = false
        self.editButtonLabel.hidden = false
        self.datePicker.hidden = true
        self.bDayLabel.hidden = false
        
        dateFromPickerString = dateClass.userBirthDayString(datePicker.date)
        
        if let unwrappedString = dateFromPickerString
        {
            self.bDayLabel.text = unwrappedString
        }
        
        
    }
    
    
    //goes straight to their horoscope based on the data saved
    @IBAction func goToHoroscopeButton(sender: AnyObject)
    {
        store.fetchData()
        birthdayFromStore = Int(store.individual!.birthdate)
        if let unwrappedBirthdayFromStore = birthdayFromStore
        {
            savedString = dateClass.gettingHoroscopeString(unwrappedBirthdayFromStore)
        }
        
        print("goToHoroscopeButton Pressed")
        print(savedString)
        
    }
    
    //deletes the old data
    @IBAction func editButton(sender: AnyObject)
    {

        let updateAlert = UIAlertController.init(title: "Edit Birthday?", message: "Are you sure that you want to edit your birthday?", preferredStyle: .Alert)
        
        let noAction = UIAlertAction.init(title: "No, cancel", style: .Cancel) { (action) in
        }
        
        let yesAction = UIAlertAction.init(title: "Yes, Edit", style: .Default) { (action) in
        
            self.store.updateData()
            self.submitButtonLabel.hidden = false
            self.goToHoroscopeButtonLabel.hidden = true
            self.editButtonLabel.hidden = true
            self.selectBirthdayLabel.text = "Please select your birthday"
            self.datePicker.hidden = false
            self.bDayLabel.hidden = true
            print("Update Pressed")
            
        }
        updateAlert.addAction(noAction)
        updateAlert.addAction(yesAction)
        
        self.presentViewController(updateAlert, animated: true){
        }
        
    }
    

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "submitButtonSegue"
        {
            let destinationVC = segue.destinationViewController as? HoroscopeViewController
        
            let startDate = dateClass.setStartingDate()
            let userBirthdayDate = dateClass.setEndDate(datePicker.date)
            let horoToBeSegued = dateClass.passingTheHoroscope(startDate, endDate:userBirthdayDate)
        
            destinationVC?.passedHoroscopeString = horoToBeSegued
            
        }
        
        if segue.identifier == "goToYourHoroscopeSegue"
        {
            let destVC = segue.destinationViewController as! HoroscopeViewController
            
            if let unwrappedBirthdayFromStore = birthdayFromStore
            {
                let savedUserBirthday = dateClass.gettingHoroscopeString(unwrappedBirthdayFromStore)
                destVC.passedHoroscopeString = savedUserBirthday
            }
 
        }
        
    }

}



