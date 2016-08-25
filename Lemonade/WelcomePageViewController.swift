//
//  WelcomePageViewController.swift
//  Lemonade
//
//  Created by Flatiron School on 8/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class WelcomePageViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var buttonLabel: UIButton!
    var welcomeLabel = UILabel()
    
    var personUsername = ""
    var personBirthdate : Int32 = 0
    
    
    let store = DataStore.sharedDataStore
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        checkForText()
        welcomeLabelConstraints()
        welcomeLabel.alpha = 0.0
        welcomeLabelAnimation()
        buttonConstraint()
        
        let imageData = NSData(contentsOfURL: NSBundle.mainBundle().URLForResource("giphy (4)", withExtension: "gif")!)
        let imageGif = UIImage.gifWithData(imageData!)
        let imageView = UIImageView(image: imageGif)
        
    
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        imageView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        imageView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
        imageView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        view.sendSubviewToBack(imageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(WelcomePageViewController.tap(_:)))
        view.addGestureRecognizer(tapGesture)
        view.addSubview(buttonLabel)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func checkForText()
    {
        if nameTextField.text?.characters.count == 0
        {
            buttonLabel.hidden = true
            buttonLabel.alpha = 0.0
        }
        
    }
    
    func welcomeLabelConstraints()
    {
        
        self.welcomeLabel.text = "Welcome"
        self.welcomeLabel.font = UIFont(name: "BradleyHandITCTT-Bold", size: 50.0)
        self.welcomeLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(self.welcomeLabel)
        
        
        self.welcomeLabel.removeConstraints(self.welcomeLabel.constraints)
        self.welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.welcomeLabel.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        self.welcomeLabel.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: -130).active = true
    }
    
    func buttonConstraint()
    {
        self.buttonLabel.titleLabel?.textColor = UIColor.whiteColor()
        self.buttonLabel.layer.borderWidth = 1
        self.buttonLabel.layer.borderColor = UIColor.whiteColor().CGColor
        self.buttonLabel.layer.cornerRadius = 10
        self.buttonLabel.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.2)
    }
    
    func welcomeLabelAnimation()
    {
        UIView.animateWithDuration(2.0)
        {
            self.welcomeLabel.alpha = 1.0
            
            self.view.layoutIfNeeded()
        }
    }
    
    
    @IBAction func buttonAction(sender: AnyObject)
    {
        
        let userRequest = NSFetchRequest(entityName: Users.entityName)
        
        do{
            let object = try store.managedObjectContext.executeFetchRequest(userRequest) as? [Users]
            
            if object?.count == 0
            {
                let person = NSEntityDescription.insertNewObjectForEntityForName(Users.entityName, inManagedObjectContext: store.managedObjectContext) as! Users
                
                if let unwrappedText = nameTextField.text
                {
                    person.username = unwrappedText
                    person.birthdate = 0
                    
                    store.saveContext()
                }
                
            }
                
            else if object?.count != 0
            {
                let person = store.individual
                
                if let unwrappedText = nameTextField.text
                {
                    person?.username = unwrappedText
                    
                    store.saveContext()
                }
                
            }
        }
        catch{print("error")}
        
        }
    

    func tap(gesture: UITapGestureRecognizer)
    {
        self.nameTextField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        UIView.animateWithDuration(1.0)
        {
            self.buttonLabel.hidden = false
            self.buttonLabel.alpha = 1.0
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.nameTextField.resignFirstResponder()
        return true
    }
    
}