//
//  ViewController.swift
//  Lemonade
//
//  Created by Flatiron School on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class HoroscopeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        HoroscopeAPIClient.getDailyHoroscope { (zodiacTodayDictionary) in
            
            print(zodiacTodayDictionary)
            
        }
        
        NASA_API_Client.getPhotoOfDay { (spaceImage) in
            self.imageView.image = spaceImage
            self.view.addSubview(self.imageView)
            self.imageView.translatesAutoresizingMaskIntoConstraints = false// any automatic stuff you thought you should do, don't do that
            self.imageView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
            self.imageView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
            self.imageView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
            self.imageView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
            
            
            }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

