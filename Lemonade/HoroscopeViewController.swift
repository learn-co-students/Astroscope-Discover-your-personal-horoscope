//
//  ViewController.swift
//  Lemonade
//
//  Created by Flatiron School on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class HoroscopeViewController: UIViewController {
    
    var imageView = UIImageView()
    var passedHoroscopeString: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        NASA_API_Client.getPhotoOfDay { (spaceImage) in
            self.imageView.image = spaceImage
            self.view.addSubview(self.imageView)
            
            self.imageView.translatesAutoresizingMaskIntoConstraints = false
            self.imageView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
            self.imageView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
            self.imageView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
            self.imageView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
            
        }
        
        HoroscopeAPIClient.getDailyHoroscope(passedHoroscopeString) { (zodiacDictionary) in
            print(zodiacDictionary)
        }
        
        
        //because passing everything in as arguments, viewController calls method. save susan's return variable and pop the return into getDailyHoroscope function.
//        
//        var sunSign = Libra
//        HoroscopeAPIClient.getDailyHoroscope{(sunSign, completion: )
        
//        HoroscopeAPIClient.getDailyHoroscope { (zodiacTodayDictionary) in
//            
//            print(zodiacTodayDictionary)
//            
//        }
//        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

