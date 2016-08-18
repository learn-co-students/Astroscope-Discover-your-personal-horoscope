//
//  ViewController.swift
//  Lemonade
//
//  Created by Flatiron School on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData
import AssetsLibrary

class HoroscopeViewController: UIViewController {
    
    @IBOutlet weak var testview: UIButton!
    var imageView = UIImageView()
    var passedHoroscopeString: String?
    
    let saveNASAImageToCameraRollButton = UIButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       createSaveImageButton()
       saveImageButtonTapped()
        
        NASA_API_Client.getPhotoOfDay { (spaceImage) in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
            self.imageView.image = spaceImage
            self.view.addSubview(self.imageView)
            self.imageView.translatesAutoresizingMaskIntoConstraints = false
            self.imageView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
            self.imageView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
            self.imageView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
            self.imageView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
                
                self.view.sendSubviewToBack(self.imageView)
             })
        }
        
        guard let unwrappedPassedHoroscopeString = passedHoroscopeString else {return}
        HoroscopeAPIClient.getDailyHoroscope(unwrappedPassedHoroscopeString) { (zodiacDictionary) in
            print(zodiacDictionary)
        }
    }

    
    func createSaveImageButton () {
        
        saveNASAImageToCameraRollButton.backgroundColor = UIColor.whiteColor()
        saveNASAImageToCameraRollButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        saveNASAImageToCameraRollButton.setTitle("Save Image To Camera Roll", forState: UIControlState.Normal)
        saveNASAImageToCameraRollButton.frame = CGRectMake(100, 100, 100, 50)
        saveNASAImageToCameraRollButton.layer.cornerRadius = 5
        saveNASAImageToCameraRollButton.layer.borderWidth = 1
        saveNASAImageToCameraRollButton.layer.borderColor = UIColor.blueColor().CGColor
        saveNASAImageToCameraRollButton.addTarget(self, action: #selector (saveImageButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(saveNASAImageToCameraRollButton)
        
        
        self.saveNASAImageToCameraRollButton.translatesAutoresizingMaskIntoConstraints = false
        self.saveNASAImageToCameraRollButton.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor, constant: 0).active = true
        self.saveNASAImageToCameraRollButton.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant: 0).active = true
 
    }
    
    func saveImageButtonTapped () {

        if let unwrappedImage = imageView.image {

            UIImageWriteToSavedPhotosAlbum(unwrappedImage, self, nil, nil)
            let savedAlertController = UIAlertController(title: "", message: "Saved Image!", preferredStyle: .Alert)
            savedAlertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(savedAlertController, animated: true, completion: nil)
            savedAlertController.view.backgroundColor = UIColor.blackColor()
            savedAlertController.view.tintColor = UIColor.blackColor()
        }
        
        else {
            let savedAlertControllerError = UIAlertController(title: "Save error", message: "error", preferredStyle: .Alert)
            savedAlertControllerError.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(savedAlertControllerError, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


