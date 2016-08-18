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
    
    let saveNASAImageToCameraRollButton = UIButton.init(type: UIButtonType.System) as UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       createSaveImageButton()
        
        
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
        
           
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    
    
    func createSaveImageButton () {
        saveNASAImageToCameraRollButton.backgroundColor = UIColor.greenColor()
        saveNASAImageToCameraRollButton.setTitle("Save Image To Camera Roll", forState: UIControlState.Normal)
        saveNASAImageToCameraRollButton.frame = CGRectMake(100, 100, 100, 50)
        saveNASAImageToCameraRollButton.addTarget(self, action: #selector (saveImageButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(saveNASAImageToCameraRollButton)

        
    }
    
    func saveImageButtonTapped () {
        
        
        
        if let unwrappedImage = imageView.image {

        UIImageWriteToSavedPhotosAlbum(unwrappedImage, self, nil, nil)
            
    
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    
 


}


