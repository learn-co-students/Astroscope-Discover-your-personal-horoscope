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
    
    
    var startDate : Date?
    var userBirthday : Date?
    
    
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
    
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "giphy (3)", withExtension: "gif")!)
        let imageGif = UIImage.gifWithData(imageData!)
        let imageView = UIImageView(image: imageGif)
       
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        view.sendSubview(toBack: imageView)
        
        self.datePicker.backgroundColor = UIColor.clear
        self.datePicker.setValue(UIColor.white, forKeyPath: "textColor")
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
            self.submitButtonLabel.isHidden = true
        
            self.labelFormat()
            
            self.goToHoroscopeButtonLabel.isHidden = false
            
            self.editButtonLabel.isHidden = false
            self.datePicker.isHidden = true
            self.bDayLabel.isHidden = false
            
        
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
            self.startDate = dateClass.setStartingDate() as Date
            
            self.submitButtonLabel.isHidden = false
            self.goToHoroscopeButtonLabel.isHidden = true
            self.editButtonLabel.isHidden = true
            self.datePicker.isHidden = false
            self.bDayLabel.isHidden = true
            
            let name = store.individual?.username
            self.selectBirthdayLabel.text = "Hello \(name!)\n Select your birthday"
        }
            
    
    
    }


    //Gets user's input from date picker
    @IBAction func datePickerAction(_ sender: AnyObject)
    {
        self.dateFromPickerString = dateClass.userBirthDayString(datePicker.date)
    }
    
    
    //Will save the user's input
    @IBAction func submitButton(_ sender: AnyObject)
    {
        self.submitButtonLabel.isHidden = true
        self.selectBirthdayLabel.text = "Welcome Back \n \(store.individual!.username)"
        self.userBirthday = self.dateClass.setEndDate(self.datePicker.date)
        
                
        let person = store.individual
        
        let start = dateClass.setStartingDate()
        let userBday = dateClass.setEndDate(datePicker.date)
        
        let birthDateInt = Int32(self.dateClass.daysBetweenDates(start, endDate: userBday))
        
        person?.birthdate = birthDateInt
       
        store.saveContext()
                
        self.goToHoroscopeButtonLabel.isHidden = false
        self.editButtonLabel.isHidden = false
        self.datePicker.isHidden = true
        self.bDayLabel.isHidden = false
        
        dateFromPickerString = dateClass.userBirthDayString(datePicker.date)
        
        if let unwrappedString = dateFromPickerString
        {
            self.bDayLabel.text = unwrappedString
        }
        
        
    }
    
    
    //goes straight to their horoscope based on the data saved
    @IBAction func goToHoroscopeButton(_ sender: AnyObject)
    {
        store.fetchData()
        
        birthdayFromStore = Int(store.individual!.birthdate)
        if let unwrappedBirthdayFromStore = birthdayFromStore
        {
            self.savedString = dateClass.gettingHoroscopeString(unwrappedBirthdayFromStore)
        }

    }
    
    //deletes the old data
    @IBAction func editButton(_ sender: AnyObject)
    {

        let editAlert = UIAlertController.init(title: "Edit Info?", message: "Which of the following would you like to edit?", preferredStyle: .alert)
        
        let noAction = UIAlertAction.init(title: "No, cancel", style: .cancel) { (action) in
        }
        
        let birthdayAction = UIAlertAction.init(title: "Edit Birthday", style: .default) { (action) in
            
            self.labelFormat()
            self.submitButtonLabel.isHidden = false
            self.goToHoroscopeButtonLabel.isHidden = true
            self.editButtonLabel.isHidden = true
            self.selectBirthdayLabel.text = "Edit Birthday"
            self.datePicker.isHidden = false
            self.bDayLabel.isHidden = true
            
        }
        
        let usernameAction = UIAlertAction.init(title: "Edit Name", style: .default) { (action) in
            self.performSegue(withIdentifier: "welcomePageSegue", sender: self)
        }
        editAlert.addAction(noAction)
        editAlert.addAction(birthdayAction)
        editAlert.addAction(usernameAction)
        
        self.present(editAlert, animated: true){
        }
        
    }    
    
    func labelFormat()
    {
        self.submitButtonLabel.layer.borderWidth = 1
        self.submitButtonLabel.layer.borderColor = UIColor.white.cgColor
        self.submitButtonLabel.layer.cornerRadius = 10
        self.submitButtonLabel.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        self.goToHoroscopeButtonLabel.layer.borderWidth = 1
        self.goToHoroscopeButtonLabel.layer.borderColor = UIColor.white.cgColor
        self.goToHoroscopeButtonLabel.layer.cornerRadius = 10
        self.goToHoroscopeButtonLabel.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        self.editButtonLabel.layer.borderWidth = 1
        self.editButtonLabel.layer.borderColor = UIColor.white.cgColor
        self.editButtonLabel.layer.cornerRadius = 10
        self.editButtonLabel.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "submitButtonSegue"
        {
            let destinationVC = segue.destination as? HoroscopeViewController
        
            let startDate = dateClass.setStartingDate()
            let userBirthdayDate = dateClass.setEndDate(datePicker.date)
            let horoToBeSegued = dateClass.passingTheHoroscope(startDate, endDate:userBirthdayDate)
        
            destinationVC?.passedHoroscopeString = horoToBeSegued
            
        }
        
        if segue.identifier == "goToYourHoroscopeSegue"
        {
            let destVC = segue.destination as! HoroscopeViewController
            
            if let unwrappedBirthdayFromStore = birthdayFromStore
            {
                let savedUserBirthday = dateClass.gettingHoroscopeString(unwrappedBirthdayFromStore)
                destVC.passedHoroscopeString = savedUserBirthday
            }
 
        }
        
    }

}



