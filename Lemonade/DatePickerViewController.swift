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
    
    let store = DataStore()
    var birthdayFromStore: Int = 0
    var savedString = ""
    

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var startDate : NSDate!
    var userBirthday : NSDate!
    
    var dateClass = datePickerClass()
    
    @IBOutlet weak var selectBirthdayLabel: UILabel!
    @IBOutlet weak var submitButtonLabel: UIButton!
    @IBOutlet weak var goToHoroscopeButtonLabel: UIButton!
    @IBOutlet weak var editButtonLabel: UIButton!
   
    
    override func viewDidLoad()
    {

        super.viewDidLoad()

        //print(dateClass.gettingHoroscopeString(284))
        self.view.backgroundColor = UIColor.blackColor()
        self.datePicker.backgroundColor = UIColor.clearColor()
        self.datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        self.datePicker.setValue(false, forKey: "highlightsToday")
        
        
        startDate = dateClass.setStartingDate()
        userBirthday = dateClass.setEndDate(datePicker.date)
        
        print("Starting Date: \(startDate)")
        print("Today's Date: \(userBirthday)")
        
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
                }
                
            }
            else if object?.count == 0 // if none
            {
                selectBirthdayLabel.text = "Please select your birthday"
                submitButtonLabel.hidden = false
                goToHoroscopeButtonLabel.hidden = true
                editButtonLabel.hidden = true
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
        let difference = dateClass.daysBetweenDates(self.startDate, endDate: self.userBirthday)
        self.userBirthday = dateClass.setEndDate(datePicker.date)
        print("Date picked: \(self.userBirthday)")
        print("Julian date: \(difference)")
    
    }
    
    
    //Will save the user's input
    @IBAction func submitButton(sender: AnyObject)
    {
        submitButtonLabel.hidden = true
        selectBirthdayLabel.text = "Welcome Back"
        self.userBirthday = dateClass.setEndDate(datePicker.date)
        
        let context = store.managedObjectContext
        
        let birthDate = NSEntityDescription.insertNewObjectForEntityForName(Users.entityName, inManagedObjectContext: context) as NSManagedObject
        
        birthDate.setValue(dateClass.daysBetweenDates(self.startDate, endDate: self.userBirthday), forKey: "birthdate")
        
        do  {
            try context.save()
        }
        catch
        {
            print("Error")
        }
        
        store.saveContext()
        print("SubmitButton Pressed")
        
        goToHoroscopeButtonLabel.hidden = false
        editButtonLabel.hidden = false
    }
    
    //goes straight to their horoscope based on the data saved
    @IBAction func goToHoroscopeButton(sender: AnyObject)
    {
        
        birthdayFromStore = Int(store.fetchData())
        
        savedString = dateClass.gettingHoroscopeString(birthdayFromStore)
        
        print("goToHoroscopeButton Pressed")
        print(savedString)
        
        
    }
    
    //deletes the old data
    @IBAction func editButton(sender: AnyObject)
    {

        let updateAlert = UIAlertController.init(title: "Update", message: "Are you sure you want to edit your birthday?", preferredStyle: .Alert)
        
        let noAction = UIAlertAction.init(title: "No, cancel", style: .Cancel) { (action) in
        }
        
        let yesAction = UIAlertAction.init(title: "Yes, Edit", style: .Default) { (action) in
            self.store.updateData()
            self.submitButtonLabel.hidden = false
            self.goToHoroscopeButtonLabel.hidden = true
            self.editButtonLabel.hidden = true
            self.selectBirthdayLabel.text = "Please select your birthday"
            print("Update Pressed")
        }
        updateAlert.addAction(noAction)
        updateAlert.addAction(yesAction)
        
        self.presentViewController(updateAlert, animated: true)
        {
            print("hello")
        }
        
    }
    
    //haven't used this yet
    func alertControllerBackgroundTapped()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "submitButtonSegue"
        {
            let destinationVC = segue.destinationViewController as? HoroscopeViewController
        
            let horoToBeSegued = dateClass.passingTheHoroscope(startDate, endDate: userBirthday)
        
            destinationVC?.passedHoroscopeString = horoToBeSegued
            
            /**
            let submitAlert = UIAlertController.init(title: "Welcome!", message: "You are a \(horoToBeSegued)", preferredStyle: .Alert)
            
            self.presentViewController(submitAlert, animated: true, completion:
            {
                submitAlert.view.superview?.userInteractionEnabled = true
                submitAlert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            })
            */
            
        }
        
        if segue.identifier == "goToYourHoroscopeSegue"
        {
        
            let destVC = segue.destinationViewController as? HoroscopeViewController
            
            let savedUserBirthday = dateClass.gettingHoroscopeString(birthdayFromStore)
            
            destVC?.passedHoroscopeString = savedUserBirthday
            
 
        }
        
    }

}



