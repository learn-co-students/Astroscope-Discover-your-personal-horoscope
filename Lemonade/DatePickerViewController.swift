//
//  DatePickerViewController.swift
//  Team Lemonade
//
//  Created by Susan Zheng on 8/12/16.
//
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
    @IBOutlet weak var editNameNavBarLabel: UIBarButtonItem!
    
    override func viewDidLoad()
    {

        super.viewDidLoad()
    
        
        let imageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("giphy (3)", withExtension: "gif")!)
        let imageGif = UIImage.gifWithData(imageData!)
        let imageView = UIImageView(image: imageGif)
       
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        imageView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        imageView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
        imageView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        view.sendSubviewToBack(imageView)
        
        self.datePicker.backgroundColor = UIColor.clearColor()
        self.datePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        self.datePicker.setValue(false, forKey: "highlightsToday")
        
        store.fetchData()
        checkforDataWhenOpeningApp()
        
        
    }
    
    //Checks if theres any data in database when app is open
    func checkforDataWhenOpeningApp()
    {
    
       if store.individual?.birthdate != 0
       {
            self.selectBirthdayLabel.text = "Welcome back \n \(store.individual!.username)"
            self.submitButtonLabel.hidden = true
        
            self.labelFormat()
            
            self.goToHoroscopeButtonLabel.hidden = false
            
            self.editButtonLabel.hidden = false
            self.datePicker.hidden = true
            self.bDayLabel.hidden = false
            
            
            let birthDate = store.individual?.birthdate
            if let unwrappedBirthDate = birthDate
            {
                
                let start = dateClass.setStartingDate()
                let setDate = (dateClass.setDateForPicker(start, day: Int(unwrappedBirthDate)))
                    
                self.datePicker.setDate(setDate, animated: true)
                    
                let labelWithBdayString = dateClass.userBirthDayString(setDate)
                self.bDayLabel.text = labelWithBdayString
                    
            }
        
            
        }
        else if store.individual?.birthdate == 0
        {
    
            self.labelFormat()
            self.startDate = dateClass.setStartingDate()
            
            self.submitButtonLabel.hidden = false
            self.goToHoroscopeButtonLabel.hidden = true
            self.editButtonLabel.hidden = true
            self.datePicker.hidden = false
            self.bDayLabel.hidden = true
            
            let name = store.individual?.username
            self.selectBirthdayLabel.text = "Hello \(name!)\n, Please select your birthday"
        }
            
    
    
    }


    //Gets user's input from date picker
    @IBAction func datePickerAction(sender: AnyObject)
    {
        self.dateFromPickerString = dateClass.userBirthDayString(datePicker.date)
    }
    
    
    //Will save the user's input
    @IBAction func submitButton(sender: AnyObject)
    {
        self.submitButtonLabel.hidden = true
        self.selectBirthdayLabel.text = "Welcome Back \n \(store.individual!.username)"
        self.userBirthday = self.dateClass.setEndDate(self.datePicker.date)
        
                
        let person = store.individual
        
        let start = dateClass.setStartingDate()
        let userBday = dateClass.setEndDate(datePicker.date)
        
        let birthDateInt = Int32(self.dateClass.daysBetweenDates(start, endDate: userBday))
        
        person?.birthdate = birthDateInt
       
        store.saveContext()
                
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
            self.savedString = dateClass.gettingHoroscopeString(unwrappedBirthdayFromStore)
        }

    }
    
    //deletes the old data
    @IBAction func editButton(sender: AnyObject)
    {

        let editAlert = UIAlertController.init(title: "Edit Info?", message: "Which of the following would you like to edit?", preferredStyle: .Alert)
        
        let noAction = UIAlertAction.init(title: "No, cancel", style: .Cancel) { (action) in
        }
        
        let birthdayAction = UIAlertAction.init(title: "Edit Birthday", style: .Default) { (action) in
            
            self.labelFormat()
            self.submitButtonLabel.hidden = false
            self.goToHoroscopeButtonLabel.hidden = true
            self.editButtonLabel.hidden = true
            self.selectBirthdayLabel.text = "Edit Birthday"
            self.datePicker.hidden = false
            self.bDayLabel.hidden = true
            
        }
        
        let usernameAction = UIAlertAction.init(title: "Edit Name", style: .Default) { (action) in
            self.performSegueWithIdentifier("welcomePageSegue", sender: self)
        }
        editAlert.addAction(noAction)
        editAlert.addAction(birthdayAction)
        editAlert.addAction(usernameAction)
        
        self.presentViewController(editAlert, animated: true){
        }
        
    }    
    
    func labelFormat()
    {
        self.submitButtonLabel.layer.borderWidth = 1
        self.submitButtonLabel.layer.borderColor = UIColor.whiteColor().CGColor
        self.submitButtonLabel.layer.cornerRadius = 10
        self.submitButtonLabel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        
        self.goToHoroscopeButtonLabel.layer.borderWidth = 1
        self.goToHoroscopeButtonLabel.layer.borderColor = UIColor.whiteColor().CGColor
        self.goToHoroscopeButtonLabel.layer.cornerRadius = 10
        self.goToHoroscopeButtonLabel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
        
        self.editButtonLabel.layer.borderWidth = 1
        self.editButtonLabel.layer.borderColor = UIColor.whiteColor().CGColor
        self.editButtonLabel.layer.cornerRadius = 10
        self.editButtonLabel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
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



