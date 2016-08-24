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

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var buttonLabel: UIButton!
    
    
    let store = DataStore.sharedDataStore
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //self.nameTextField.resignFirstResponder()
        nameTextField.delegate = self
        checkForText()
        
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
    
    @IBAction func buttonAction(sender: AnyObject)
    {
        
        let context = store.managedObjectContext
        
        let user = NSEntityDescription.insertNewObjectForEntityForName(Users.entityName, inManagedObjectContext: context) as! Users
        
        if let unwrappedText = nameTextField.text
        {
            user.username = unwrappedText
            store.saveContext()
           
        }


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
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
