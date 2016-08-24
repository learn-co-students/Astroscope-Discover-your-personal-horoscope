//
//  WelcomePageViewController.swift
//  Lemonade
//
//  Created by Flatiron School on 8/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class WelcomePageViewController: UIViewController
{

    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var buttonLabel: UIButton!
    
    
    let store = DataStore.sharedDataStore
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //self.view.addSubview(self.welcomeLabel)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
     
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
 

    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
