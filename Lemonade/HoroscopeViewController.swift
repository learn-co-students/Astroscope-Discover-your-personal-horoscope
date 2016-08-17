//
//  ViewController.swift
//  Lemonade
//
//  Created by Flatiron School on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData
import SnapKit

class HoroscopeViewController: UIViewController {
    
    var imageNASAView = UIImageView()
    var passedHoroscopeString: String?
    
    var signIcon = UIImageView ()
    var dailyHoroscopeTextView: UITextView!
    var todaysDate: UILabel!
    var signName: UILabel!
    var iconsDictionary: [String: String] = ["Capricorn": "capricorn_black_parkjisun.png", "Aquarius":"aquarius_black_parkjisun.png", "Pisces" : "pisces_black_parkjisun.png", "Aries" : "aries_black_parkjisun.png", "Taurus" : "taurus_black_parkjisun.png", "Gemini" : "gemini_black_parkjisun.png", "Cancer" : "cancer_black_parkjisun.png", "Leo" : "leo_black_parkjisun.png", "Virgo" : "virgo_black_parkjisun.png", "Libra" : "libra_black_parkjisun.png", "Scorpio" : "scorpio_black_parkjisun.png", "Sagittarius" : "sagittarius_black_parkjisun.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        NASA_API_Client.getPhotoOfDay { (spaceImage) in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                
                self.imageNASAView.image = spaceImage
                self.view.addSubview(self.imageNASAView)
                
                self.imageNASAView.translatesAutoresizingMaskIntoConstraints = false
                self.imageNASAView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
                self.imageNASAView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
                self.imageNASAView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
                self.imageNASAView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
                self.view.sendSubviewToBack(self.imageNASAView)
            })
        }
        
        guard let unwrappedPassedHoroscopeString = passedHoroscopeString else {return}
        
        HoroscopeAPIClient.getDailyHoroscope(unwrappedPassedHoroscopeString) { (unwrappedZodiac) in
            
            
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                print(unwrappedZodiac)
                
                for iconKey in self.iconsDictionary.keys {
                    
                    if iconKey == unwrappedPassedHoroscopeString {
                
                self.signIcon.image = UIImage.init(named: self.iconsDictionary[iconKey]!)
                self.signIcon.layer.cornerRadius = self.signIcon.frame.size.width/2
                self.view.addSubview(self.signIcon)
                
                self.signIcon.translatesAutoresizingMaskIntoConstraints = false
                self.signIcon.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
                self.signIcon.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 20).active = true
                self.signIcon.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.20).active = true
                self.signIcon.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.40).active = true

                
                guard let unwrappedSignName = unwrappedZodiac["sunsign"] as? String else {return}
                
                self.signName = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
                self.signName.intrinsicContentSize().width
                self.signName.backgroundColor = UIColor.redColor()
                guard self.signName != nil else {return}
                self.signName.text = unwrappedSignName
                self.signName.textAlignment = NSTextAlignment.Center
                self.view.addSubview(self.signName)
                self.signName.translatesAutoresizingMaskIntoConstraints = false
                self.signName.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
                self.signName.topAnchor.constraintEqualToAnchor(self.signIcon.bottomAnchor, constant: 10).active = true
                self.signName.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.25).active = true
                self.signName.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.25).active = true
                
                print(unwrappedSignName)
                
                
                guard let unwrappedTodaysDate = unwrappedZodiac["date"] as? String else {return}
                self.todaysDate = UILabel()
                self.todaysDate.backgroundColor = UIColor.blueColor()
                guard self.todaysDate != nil else {return}
                self.todaysDate.text = unwrappedTodaysDate
                self.view.addSubview(self.todaysDate)
                self.todaysDate.translatesAutoresizingMaskIntoConstraints = false
                self.todaysDate.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
                self.todaysDate.topAnchor.constraintEqualToAnchor(self.signName.bottomAnchor, constant: 10).active = true
                self.todaysDate.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.25).active = true
                self.todaysDate.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.25).active = true
                
                
                print(unwrappedTodaysDate)
                
                
                guard let unwrappedHoroscopeValue = unwrappedZodiac["horoscope"] as? String else {return}
                self.dailyHoroscopeTextView = UITextView()
                self.dailyHoroscopeTextView.backgroundColor = UIColor.yellowColor()
                guard self.dailyHoroscopeTextView != nil else {return}
                self.dailyHoroscopeTextView.text = unwrappedHoroscopeValue
                self.view.addSubview(self.dailyHoroscopeTextView)
                
                self.dailyHoroscopeTextView.translatesAutoresizingMaskIntoConstraints = false
                self.dailyHoroscopeTextView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
                self.dailyHoroscopeTextView.topAnchor.constraintEqualToAnchor(self.todaysDate.bottomAnchor, constant: 10).active = true
                self.dailyHoroscopeTextView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.50).active = true
                self.dailyHoroscopeTextView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.50).active = true
                
                print(unwrappedHoroscopeValue)
                }

                }
                
            })
            
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


