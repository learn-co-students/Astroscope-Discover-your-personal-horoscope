//
//  WelcomePageViewController.swift
//  Team Lemonade
//
//  Created by Susan Zheng on 8/23/16.
//
//

import UIKit
import CoreData

class WelcomePageViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var buttonLabel: UIButton!
    var welcomeLabel = UILabel()
    var pleaseEnterNameLabel = UILabel()
    let store = DataStore.sharedDataStore
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        checkForText()
        checkForDataForWelcomeLabel()
        //welcomeLabel.alpha = 0.0
        //pleaseEnterNameConstraints()
        buttonConstraint()
        
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "giphy (4)", withExtension: "gif")!)
        let imageGif = UIImage.gifWithData(imageData!)
        let imageView = UIImageView(image: imageGif)
        
    
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        view.sendSubview(toBack: imageView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(WelcomePageViewController.tap(_:)))
        view.addGestureRecognizer(tapGesture)
        view.addSubview(buttonLabel)

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    
    func checkForDataForWelcomeLabel()
    {
        let userRequest = NSFetchRequest<Users>(entityName: Users.entityName)
        
        do{
            let object = try store.managedObjectContext.fetch(userRequest)
            
            if object.count == 0
            {
                self.welcomeLabel.text = "Welcome"
                welcomeLabel.alpha = 0.0
                welcomeLabelConstraints()
                pleaseEnterNameLabel.alpha = 0.0
                pleaseEnterNameLabel.text = "Please enter your name"
                pleaseEnterNameConstraints()
                welcomeLabelAnimation()
                
            }
            else if object.count != 0
            {
                self.welcomeLabel.text = "Edit Name"
                welcomeLabelConstraints()
            }
        }
        catch{print("Error")}
        }
    

    func checkForText()
    {
        if nameTextField.text?.characters.count == 0
        {
            buttonLabel.isHidden = true
            buttonLabel.alpha = 0.0
        }
        
    }
    
    func welcomeLabelConstraints()
    {
        self.view.addSubview(self.welcomeLabel)
        self.welcomeLabel.font = UIFont(name: "BradleyHandITCTT-Bold", size: 50.0)
        self.welcomeLabel.textColor = UIColor.white
        self.welcomeLabel.removeConstraints(self.welcomeLabel.constraints)
        self.welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.welcomeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.welcomeLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -130).isActive = true
    }
    
    func pleaseEnterNameConstraints()
    {
        self.view.addSubview(self.pleaseEnterNameLabel)
        self.pleaseEnterNameLabel.removeConstraints(self.pleaseEnterNameLabel.constraints)
        self.pleaseEnterNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.pleaseEnterNameLabel.font = UIFont(name: "BradleyHandITCTT-Bold", size: 20.0)
        self.pleaseEnterNameLabel.textColor = UIColor.white
        //self.pleaseEnterNameLabel.text = ""
        self.pleaseEnterNameLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.pleaseEnterNameLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50).isActive = true
    }
    func buttonConstraint()
    {
        self.buttonLabel.titleLabel?.textColor = UIColor.white
        self.buttonLabel.layer.borderWidth = 1
        self.buttonLabel.layer.borderColor = UIColor.white.cgColor
        self.buttonLabel.layer.cornerRadius = 10
        self.buttonLabel.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    }
    
    func welcomeLabelAnimation()
    {
        UIView.animate(withDuration: 1.5, animations:
        {
            self.welcomeLabel.alpha = 1.0
        }, completion: { (true) in
            
            UIView.animate(withDuration: 1.0, animations:
                {
                self.pleaseEnterNameLabel.alpha = 1.0
            })
        }) 
    }
    @IBAction func buttonAction(_ sender: AnyObject)
    {
        
        let userRequest = NSFetchRequest<Users>(entityName: Users.entityName)
        
        do{
            let object = try store.managedObjectContext.fetch(userRequest)
            
            if object.count == 0
            {
                let person = NSEntityDescription.insertNewObject(forEntityName: Users.entityName, into: store.managedObjectContext) as! Users
                
                if let unwrappedText = nameTextField.text
                {
                    person.username = unwrappedText
                    person.birthdate = 0
                    
                    store.saveContext()
                }
                
            }
                
            else if object.count != 0
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
    

    func tap(_ gesture: UITapGestureRecognizer)
    {
        self.nameTextField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        UIView.animate(withDuration: 1.0, animations: {
            self.buttonLabel.isHidden = false
            self.buttonLabel.alpha = 1.0
        })
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.nameTextField.resignFirstResponder()
        return true
    }
    
}
