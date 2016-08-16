//
//  ViewController.swift
//  Lemonade
//
//  Created by Flatiron School on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class HoroscopeViewController: UIViewController {
    
    var imageView = UIImageView()
    var passedHoroscopeString: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        NASA_API_Client.getPhotoOfDay { (spaceImage) in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
           
            self.imageView.image = spaceImage
            self.view.addSubview(self.imageView)
            
            self.imageView.translatesAutoresizingMaskIntoConstraints = false
            self.imageView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
            self.imageView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
            self.imageView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
            self.imageView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
             })
        }
        
        guard let unwrappedPassedHoroscopeString = passedHoroscopeString else {return}
        HoroscopeAPIClient.getDailyHoroscope(unwrappedPassedHoroscopeString) { (zodiacDictionary) in
            print(zodiacDictionary)
        }
        
           
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


