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
import AssetsLibrary

class HoroscopeViewController: UIViewController {
    
    var imageNASAView = UIImageView()
    var passedHoroscopeString: String?
    
    var signIcon = UIImageView()
    var dailyHoroscopeTextView: UITextView!
    var todaysDateLabel: UILabel!
    var todaysDate: String?
    
    var signName: UILabel!
    var iconsDictionary: [String: String] = ["Capricorn": "capricorn_black_parkjisun.png", "Aquarius":"aquarius_black_parkjisun.png", "Pisces" : "pisces_black_parkjisun.png", "Aries" : "aries_black_parkjisun.png", "Taurus" : "taurus_black_parkjisun.png", "Gemini" : "gemini_black_parkjisun.png", "Cancer" : "cancer_black_parkjisun.png", "Leo" : "leo_black_parkjisun.png", "Virgo" : "virgo_black_parkjisun.png", "Libra" : "libra_black_parkjisun.png", "Scorpio" : "scorpio_black_parkjisun.png", "Sagittarius" : "sagittarius_black_parkjisun.png"]
    
    
    let tapRecStackView = UITapGestureRecognizer()
    let returnTapRec = UITapGestureRecognizer()
    
    var iconTapRec = UITapGestureRecognizer()
    var isIconTapped: Bool = false
    var isBlurred: Bool = false
    
    var horoStackView = UIStackView()
    let stackViewBackgroundView = UIView()
    
    @IBOutlet weak var testview: UIButton!
    var imageView = UIImageView()
    
    let saveNASAImageToCameraRollButton = UIButton()
    
    let store = DataStore.sharedDataStore
    let calendar = NSCalendar.currentCalendar()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = NSDate()
        let todaysDateFormat = NSDateFormatter()
        //todaysDateFormat.dateStyle = NSDateFormatterStyle.LongStyle
        
        todaysDateFormat.dateFormat = "dd-MM-yyyy"
        todaysDate = todaysDateFormat.stringFromDate(date)
       
        print(todaysDate)
        
//        
//        guard let  yesterday = calendar.dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: []) else {return}
//        print(yesterday)
        //
        //        self.getSignIconName()
        //        self.addStackView()
        //
        //
        //        isSignIconTapped(isIconTapped)
        //        self.iconTapRec.addTarget(self, action: #selector(HoroscopeViewController.isSignIconTapped))
        //        self.tapRecStackView.addTarget(self, action: #selector(HoroscopeViewController.stackViewTapped))
        //
        
        self.view.addSubview(self.imageNASAView)
        self.imageNASAView.translatesAutoresizingMaskIntoConstraints = false
        self.imageNASAView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        self.imageNASAView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        self.imageNASAView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
        self.imageNASAView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        self.view.sendSubviewToBack(self.imageNASAView)
        
        NASA_API_Client.getPhotoOfDay { (spaceImage) in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                
                self.imageNASAView.image = spaceImage
                
            })
        }
        
        //  self.createSaveImageButton()
        
        
       
        
      //  self.signIcon = UIImageView()
        self.signIcon.clipsToBounds = true
        self.signIcon.tintColor = UIColor.whiteColor()
        //self.signIcon.userInteractionEnabled = true
        //self.signIcon.addGestureRecognizer(self.iconTapRec)
        self.signName = UILabel()
        self.signName.textAlignment = NSTextAlignment.Center
        self.signName.textColor = UIColor.whiteColor()
        self.signName.font = UIFont(name: "BradleyHandITCTT-Bold", size: 35.0)
        
        
        self.todaysDateLabel = UILabel()
        self.todaysDateLabel.text = self.todaysDate
        // guard self.todaysDateLabel != nil else {return}
        self.todaysDateLabel.textAlignment = NSTextAlignment.Center
        self.todaysDateLabel.textColor = UIColor.whiteColor()
        self.todaysDateLabel.font = UIFont(name: "BradleyHandITCTT-Bold", size: 18.0)
        
        
        self.dailyHoroscopeTextView = UITextView()
        self.dailyHoroscopeTextView.backgroundColor = UIColor.clearColor()
        guard self.dailyHoroscopeTextView != nil else {return}
        //self.dailyHoroscopeTextView.text = unwrappedHoroscopeValue
        self.dailyHoroscopeTextView.textColor = UIColor.whiteColor()
        self.dailyHoroscopeTextView.font = UIFont(name: "BradleyHandITCTT-Bold", size: 18.0)
        
       
        
        self.stackViewBackgroundView.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        self.view.addSubview(self.stackViewBackgroundView)
        
        self.stackViewBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.stackViewBackgroundView.removeConstraints(self.stackViewBackgroundView.constraints)
        self.stackViewBackgroundView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        self.stackViewBackgroundView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        self.stackViewBackgroundView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.65).active = true
        self.stackViewBackgroundView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.75).active = true
        
        
        self.horoStackView.axis = .Vertical
        self.horoStackView.distribution = .Fill
        self.horoStackView.alignment = .Fill
        self.horoStackView.spacing = 15
        
        
        self.horoStackView.addArrangedSubview(self.signIcon)
        self.horoStackView.addArrangedSubview(self.signName)
        self.horoStackView.addArrangedSubview(self.todaysDateLabel)
        self.horoStackView.addArrangedSubview(self.dailyHoroscopeTextView)
        
        self.stackViewBackgroundView.addSubview(self.horoStackView)
        
        self.horoStackView.translatesAutoresizingMaskIntoConstraints = false
        self.horoStackView.removeConstraints(self.horoStackView.constraints)
        self.horoStackView.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
        self.horoStackView.centerYAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerYAnchor).active = true
        
        
        self.signIcon.translatesAutoresizingMaskIntoConstraints = false
        self.signIcon.removeConstraints(self.signIcon.constraints)
        self.signIcon.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
        //self.signIcon.centerYAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerYAnchor).active = true
        self.signIcon.widthAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.widthAnchor, multiplier: 0.50).active = true
        self.signIcon.heightAnchor.constraintEqualToAnchor(self.signIcon.widthAnchor).active = true
        
        
        self.signName.translatesAutoresizingMaskIntoConstraints = false
        
        self.signName.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
    //  self.signName.centerYAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerYAnchor).active = true
        self.signName.widthAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.widthAnchor).active = true
     // self.signName.heightAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.heightAnchor).active = true
       
        self.todaysDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.todaysDateLabel.removeConstraints(self.todaysDateLabel.constraints)
        self.todaysDateLabel.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
//      self.todaysDateLabel.centerYAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerYAnchor).active = true
        self.todaysDateLabel.widthAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.widthAnchor).active = true
//        self.todaysDateLabel.heightAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.heightAnchor).active = true
        
        self.dailyHoroscopeTextView.translatesAutoresizingMaskIntoConstraints = false
        self.dailyHoroscopeTextView.removeConstraints(self.dailyHoroscopeTextView.constraints)
        self.dailyHoroscopeTextView.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
//      self.dailyHoroscopeTextView.centerYAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerYAnchor).active = true
        self.dailyHoroscopeTextView.widthAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.widthAnchor, multiplier: 0.90).active = true
        self.dailyHoroscopeTextView.heightAnchor.constraintEqualToAnchor(self.dailyHoroscopeTextView
            .widthAnchor).active = true
        
       //
        //        self.signIcon.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
        //        self.signIcon.widthAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.widthAnchor, multiplier: 0.65).active = true
        //        self.signIcon.heightAnchor.constraintEqualToAnchor(self.signIcon.widthAnchor).active = true
        //
        //        self.signName.widthAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.widthAnchor).active = true
        //        self.signName.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
        //        self.todaysDateLabel.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
        //
        //        self.dailyHoroscopeTextView.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
        //        self.dailyHoroscopeTextView.widthAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.widthAnchor, multiplier: 0.90).active = true
        //        self.dailyHoroscopeTextView.heightAnchor.constraintEqualToAnchor(self.dailyHoroscopeTextView.widthAnchor).active = true
        //
        
        
        
//        self.horoStackView.heightAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.heightAnchor, multiplier: 0.75).active = true
//        self.horoStackView.widthAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.widthAnchor, multiplier: 0.65).active = true
        
      
        //        self.horoStackView.translatesAutoresizingMaskIntoConstraints = false
        //        self.horoStackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        //        self.horoStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        //
        
        
//        self.horoStackView.translatesAutoresizingMaskIntoConstraints = false
//        self.horoStackView.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
//        self.horoStackView.centerYAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerYAnchor).active = true
//        
//        self.stackViewBackgroundView.userInteractionEnabled = true
//        //self.horoStackView.userInteractionEnabled = true
//        
//        
//        
//        //self.tapRecStackView.addTarget(self, action: #selector(HoroscopeViewController.stackViewTapped))
//        
//        self.stackViewBackgroundView.addGestureRecognizer(self.tapRecStackView)
//        //self.horoStackView.addGestureRecognizer(self.tapRecStackView)
//        
//        self.stackViewBackgroundView.addGestureRecognizer(self.returnTapRec)
//        //self.horoStackView.addGestureRecognizer(self.returnTapRec)
        
        
//        
//        
//        
//        HoroscopeAPIClient.getAnyDayHoroscope(todaysDate!, sign: unwrappedPassedHoroscopeString) {(unwrappedZodiac) in
//            
//            guard let unwrappedSignName = unwrappedZodiac["sunsign"] as? String else {return}
//            //guard self.signName != nil else {return}
//            
//            guard let unwrappedHoroscopeDate = unwrappedZodiac["date"] as? String else {return}
//            
//            
//            guard let unwrappedHoroscopeValue = unwrappedZodiac["horoscope"] as? String else {return}
//            
//            
//            if unwrappedHoroscopeDate == self.todaysDate {
//                
//                NSOperationQueue.mainQueue().addOperationWithBlock{(
//                    
//                    self.dailyHoroscopeTextView.text = unwrappedHoroscopeValue
//                    
//                    )}
//                print(unwrappedHoroscopeValue)
//                
//            } else {
//                if self.dailyHoroscopeTextView.text == "" {
//                    NSOperationQueue.mainQueue().addOperationWithBlock{(
//                        
//                        self.dailyHoroscopeTextView.text = unwrappedHoroscopeValue
//                        
//                        )}
//                }
//            }
//            
//            NSOperationQueue.mainQueue().addOperationWithBlock({
//                
//                self.signIcon.image = UIImage(named: self.iconsDictionary[unwrappedPassedHoroscopeString]!)
//                self.signName.text = unwrappedSignName
//                // self.todaysDateLabel.text = unwrappedHoroscopeDate
//                //self.dailyHoroscopeTextView.text = unwrappedHoroscopeValue
//                
//            })
//            
//        }
//    }
    
        //            )}
        
        
        
        
        
        
     //   guard let todaysDate  = unwrappedTodaysDate as? String else {return}
        
                guard let unwrappedPassedHoroscopeString = self.passedHoroscopeString else {return}
        
        
                HoroscopeAPIClient.getDailyHoroscope(unwrappedPassedHoroscopeString) { (unwrappedZodiac) in
        
                    guard let unwrappedSignName = unwrappedZodiac["sunsign"] as? String else {return}
                    //guard self.signName != nil else {return}
        
                    guard let unwrappedHoroscopeDate = unwrappedZodiac["date"] as? String else {return}
        
        
                    guard let unwrappedHoroscopeValue = unwrappedZodiac["horoscope"] as? String else {return}
        
        
                    if unwrappedHoroscopeDate == self.todaysDate {
        
                        NSOperationQueue.mainQueue().addOperationWithBlock{(
        
                            self.dailyHoroscopeTextView.text = unwrappedHoroscopeValue
        
                            )}
                        print(unwrappedHoroscopeValue)
        
                    } else {
                        if self.dailyHoroscopeTextView.text == "" {
                            NSOperationQueue.mainQueue().addOperationWithBlock{(
        
                                self.dailyHoroscopeTextView.text = unwrappedHoroscopeValue
        
                                )}
                        }
                    }
        
                    NSOperationQueue.mainQueue().addOperationWithBlock({
        
                        self.signIcon.image = UIImage(named: self.iconsDictionary[unwrappedPassedHoroscopeString]!)
                        self.signName.text = unwrappedSignName
                        // self.todaysDateLabel.text = unwrappedHoroscopeDate
                        //self.dailyHoroscopeTextView.text = unwrappedHoroscopeValue
        
                    })
        
                }
        
            }
        
    
        func stackViewTapped(isBool: Bool){
            print("A")
            
            
            //        let tapRecTextField = UITapGestureRecognizer()
            //        let returnTapRec = UITapGestureRecognizer()
            //        var isBlurred: Bool = false
            //
            //        var horoStackView = UIStackView()
            //
            if !UIAccessibilityIsReduceTransparencyEnabled(){
                print("hi")
                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                
                if isBlurred == false {
                    print("bye")
                    
                    blurEffectView.frame = self.view.bounds
                    blurEffectView.autoresizingMask = .FlexibleWidth
                    blurEffectView.autoresizingMask = .FlexibleHeight
                    
                    self.view.addSubview(blurEffectView)
                    
                    horoStackView.hidden = false
                    self.stackViewBackgroundView.hidden = false
                    
                    view.bringSubviewToFront(horoStackView)
                    
                    isBlurred = true
                    
                } else if returnTapRec.enabled == true {
                    print("tapped")
                    
                    if isBlurred == true {
                        print("nihao")
                        
                        horoStackView.hidden = true
                        self.stackViewBackgroundView.hidden = true
                        
                        for subview in view.subviews{
                            print("hola")
                            if subview is UIVisualEffectView{
                                subview.removeFromSuperview()
                            }
                            
                        }
                        
                    }
                }
            }
            
        }
        
        
        func isSignIconTapped(isBool : Bool){
            
            //  self.iconTapRec.addTarget(self, action: #selector(HoroscopeViewController.isSignIconTapped))
            
            
            if isIconTapped == true {
                
                horoStackView.tintColor = UIColor.whiteColor()
            } else {
                horoStackView.tintColor = UIColor.blackColor()
                
            }
            
            
        }
        
        
        //    func getSignIconName() -> String {
        //
        //        var iconName = String()
        //
        //        if let unwrappedPassedHoroscopeString = passedHoroscopeString {
        //
        //        for iconKey in self.iconsDictionary.keys {
        //
        //            if iconKey == unwrappedPassedHoroscopeString {
        //
        //            iconName = self.iconsDictionary[iconKey]!
        //
        //
        //            }
        //
        //            }
        //        }
        //        return iconName
        //    }
        //
        
        //
        //    func addStackView(){
        //        print("add stack view")
        //
        //        let stackViewBackgroundView = UIView()
        //        stackViewBackgroundView.backgroundColor = UIColor.grayColor()
        //        self.view.addSubview(stackViewBackgroundView)
        //        stackViewBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        //        stackViewBackgroundView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        //        stackViewBackgroundView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        //        stackViewBackgroundView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.85).active = true
        //        stackViewBackgroundView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.85).active = true
        //
        //        signIcon.clipsToBounds = true
        //        signIcon.image = UIImage(named: self.getSignIconName())
        //
        //
        //        let signLabel = UILabel()
        //        signLabel.text = "Scorpio"
        //
        //        let dateLabel = UILabel()
        //        dateLabel.text = "Today's date"
        //
        //        let horoscope = UITextView()
        //        horoscope.text = "Let's see if this works!!!!!!"
        
        //        self.horoStackView = UIStackView()
        //        self.horoStackView.axis = .Vertical
        //        self.horoStackView.distribution = .Fill
        //        self.horoStackView.alignment = .Fill
        //        self.horoStackView.spacing = 20
        //
        //        self.horoStackView.addArrangedSubview(signIcon)
        //        self.horoStackView.addArrangedSubview(signName)
        //        self.horoStackView.addArrangedSubview(todaysDate)
        //        self.horoStackView.addArrangedSubview(dailyHoroscopeTextView)
        //
        //        stackViewBackgroundView.addSubview(self.horoStackView)
        //
        //        signIcon.widthAnchor.constraintEqualToAnchor(stackViewBackgroundView.widthAnchor, multiplier: 0.7).active = true
        //        signIcon.heightAnchor.constraintEqualToAnchor(signIcon.widthAnchor).active = true
        //
        //        dailyHoroscopeTextView.widthAnchor.constraintEqualToAnchor(stackViewBackgroundView.widthAnchor, multiplier: 0.7).active = true
        //        dailyHoroscopeTextView.heightAnchor.constraintEqualToAnchor(dailyHoroscopeTextView.widthAnchor).active = true
        //
        //        self.horoStackView.translatesAutoresizingMaskIntoConstraints = false
        //
        //        self.horoStackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        //        self.horoStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        //
        //
        //
        //
        //
        //    }
        
        
        
        
        //}
        
        
        func createSaveImageButton () {
            
            self.view.addSubview(saveNASAImageToCameraRollButton)
            self.saveNASAImageToCameraRollButton.translatesAutoresizingMaskIntoConstraints = false
            self.saveNASAImageToCameraRollButton.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor, constant: 0).active = true
            self.saveNASAImageToCameraRollButton.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor, constant: 0).active = true
            saveNASAImageToCameraRollButton.backgroundColor = UIColor.whiteColor()
            saveNASAImageToCameraRollButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            saveNASAImageToCameraRollButton.setTitle("Save Image To Camera Roll", forState: UIControlState.Normal)
            saveNASAImageToCameraRollButton.frame = CGRectMake(100, 100, 100, 50)
            saveNASAImageToCameraRollButton.layer.cornerRadius = 5
            saveNASAImageToCameraRollButton.layer.borderWidth = 1
            saveNASAImageToCameraRollButton.layer.borderColor = UIColor.blueColor().CGColor
            saveNASAImageToCameraRollButton.addTarget(self, action: #selector (saveImageButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        func saveImageButtonTapped () {
            
            if let unwrappedImage = imageView.image {
                
                UIImageWriteToSavedPhotosAlbum(unwrappedImage, self, nil, nil)
                let savedAlertController = UIAlertController(title: "", message: "Saved Image!", preferredStyle: .Alert)
                savedAlertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                presentViewController(savedAlertController, animated: true, completion: nil)
                savedAlertController.view.backgroundColor = UIColor.blackColor()
                savedAlertController.view.tintColor = UIColor.blackColor()
                
                
                
            } else {
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


