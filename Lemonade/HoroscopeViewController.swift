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
    
    var signIcon = UIImageView ()
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var date = NSDate()
        let todaysDateFormat = NSDateFormatter()
        todaysDateFormat.dateStyle = NSDateFormatterStyle.LongStyle
      
       // todaysDateFormat.dateFormat = "dd-MM-yyyy"

        todaysDate = todaysDateFormat.stringFromDate(date)
        print(todaysDate)
//    
//        self.getSignIconName()
//        self.addStackView()
//        
//
//        isSignIconTapped(isIconTapped)
//        self.iconTapRec.addTarget(self, action: #selector(HoroscopeViewController.isSignIconTapped))
//        self.tapRecStackView.addTarget(self, action: #selector(HoroscopeViewController.stackViewTapped))
//        
       
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

       self.createSaveImageButton()
       
        
        
        guard let unwrappedPassedHoroscopeString = self.passedHoroscopeString else {return}
        
        HoroscopeAPIClient.getDailyHoroscope(unwrappedPassedHoroscopeString) { (unwrappedZodiac) in
            
            
            NSOperationQueue.mainQueue().addOperationWithBlock({
                print(unwrappedZodiac)
                
                
                for iconKey in self.iconsDictionary.keys {
                    
                    if iconKey == unwrappedPassedHoroscopeString {
                        
                        self.signIcon.clipsToBounds = true
                        self.signIcon.image = UIImage(named: self.iconsDictionary[iconKey]!)
                        self.signIcon.tintColor = UIColor.whiteColor()
                        
                        
                        
                        self.signIcon.userInteractionEnabled = true
                        self.signIcon.addGestureRecognizer(self.iconTapRec)
                        self.signIcon.translatesAutoresizingMaskIntoConstraints = false
                        //                self.signIcon.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
                        //                self.signIcon.topAnchor.constraintEqualToAnchor(self.view.topAnchor, constant: 20).active = true
                        //               self.signIcon.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.20).active = true
                        //               self.signIcon.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.40).active = true
                        //
                        //
                        guard let unwrappedSignName = unwrappedZodiac["sunsign"] as? String else {return}
                        
                        self.signName = UILabel()
                        //self.signName = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 5))
                        // self.signName.intrinsicContentSize().width
                        // self.signName.backgroundColor = UIColor.redColor()
                        guard self.signName != nil else {return}
                        self.signName.text = unwrappedSignName
                        self.signName.textAlignment = NSTextAlignment.Center
                        self.signName.textColor = UIColor.whiteColor()
                        self.signName.font = UIFont(name: "BradleyHandITCTT-Bold", size: 35.0)
                        //              self.horoStackView.addSubview(self.signName)
                        //                self.signName.translatesAutoresizingMaskIntoConstraints = false
                        //                self.signName.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
                        //                self.signName.topAnchor.constraintEqualToAnchor(self.signIcon.bottomAnchor, constant: 10).active = true
                        //                self.signName.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.05).active = true
                        //self.signName.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.25).active = true
                        
                        print(unwrappedSignName)
                        
                        
                        guard let unwrappedHoroscopeDate = unwrappedZodiac["date"] as? String else {return}
                        self.todaysDateLabel = UILabel()
                        self.todaysDateLabel.text = self.todaysDate
                        
                        
                        guard let unwrappedHoroscopeValue = unwrappedZodiac["horoscope"] as? String else {return}
                        self.dailyHoroscopeTextView = UITextView()
                        self.dailyHoroscopeTextView.backgroundColor = UIColor.clearColor()
                        // self.dailyHoroscopeTextView.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
                        guard self.dailyHoroscopeTextView != nil else {return}
                        //self.dailyHoroscopeTextView.text = unwrappedHoroscopeValue
                        self.dailyHoroscopeTextView.textColor = UIColor.whiteColor()
                        self.dailyHoroscopeTextView.font = UIFont(name: "BradleyHandITCTT-Bold", size: 18.0)
                        //                self.horoStackView.addSubview(self.dailyHoroscopeTextView)
                        
                        //                self.dailyHoroscopeTextView.translatesAutoresizingMaskIntoConstraints = false
                        //                self.dailyHoroscopeTextView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
                        //                self.dailyHoroscopeTextView.topAnchor.constraintEqualToAnchor(self.todaysDate.bottomAnchor, constant: 10).active = true
                        //                self.dailyHoroscopeTextView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.50).active = true
                        //                self.dailyHoroscopeTextView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.50).active = true
                        //
                       // print(unwrappedHoroscopeValue)
//                        
//                        print(unwrappedHoroscopeDate)
//                        print(self.todaysDate)

                        if unwrappedHoroscopeDate == self.todaysDate {
                        
                            
                            self.dailyHoroscopeTextView.text = unwrappedHoroscopeValue
                            
                        } else {
                            if self.dailyHoroscopeTextView.text == "" {
                                self.dailyHoroscopeTextView.text = unwrappedHoroscopeValue
                                
                            }
                        }
                        
                        
                        //  self.todaysDate.backgroundColor = UIColor.blueColor()
                        guard self.todaysDateLabel != nil else {return}
                       // self.todaysDateLabel.text = unwrappedTodaysDate
                        self.todaysDateLabel.textAlignment = NSTextAlignment.Center
                        self.todaysDateLabel.textColor = UIColor.whiteColor()
                        self.todaysDateLabel.font = UIFont(name: "BradleyHandITCTT-Bold", size: 18.0)
                        //                self.horoStackView.addSubview(self.todaysDate)
                        //                self.todaysDate.translatesAutoresizingMaskIntoConstraints = false
                        //                self.todaysDate.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
                        //                self.todaysDate.topAnchor.constraintEqualToAnchor(self.signName.bottomAnchor, constant: 10).active = true
                        //                self.todaysDate.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.25).active = true
                        //                self.todaysDate.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.25).active = true
                        
                      //  print(unwrappedTodaysDate)
                        
                        
                       
                        
                        self.stackViewBackgroundView.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
                        self.view.addSubview(self.stackViewBackgroundView)
                        self.stackViewBackgroundView.translatesAutoresizingMaskIntoConstraints = false
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
                        
                        self.signIcon.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
                        self.signIcon.widthAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.widthAnchor, multiplier: 0.65).active = true
                        self.signIcon.heightAnchor.constraintEqualToAnchor(self.signIcon.widthAnchor).active = true
                        
                        self.signName.widthAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.widthAnchor).active = true
                        self.signName.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
                        self.todaysDateLabel.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
                        
                        self.dailyHoroscopeTextView.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
                        self.dailyHoroscopeTextView.widthAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.widthAnchor, multiplier: 0.90).active = true
                        self.dailyHoroscopeTextView.heightAnchor.constraintEqualToAnchor(self.dailyHoroscopeTextView.widthAnchor).active = true
                        
                        
                        self.horoStackView.translatesAutoresizingMaskIntoConstraints = false
                        self.horoStackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
                        self.horoStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
                        
                        self.stackViewBackgroundView.userInteractionEnabled = true
                        self.horoStackView.userInteractionEnabled = true
                        
                        //self.tapRecStackView.addTarget(self, action: #selector(HoroscopeViewController.stackViewTapped))
                        
                        self.stackViewBackgroundView.addGestureRecognizer(self.tapRecStackView)
                        self.horoStackView.addGestureRecognizer(self.tapRecStackView)
                        
                        self.stackViewBackgroundView.addGestureRecognizer(self.returnTapRec)
                        self.horoStackView.addGestureRecognizer(self.returnTapRec)
                        
                    }
                    
                }
                
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
    
    
    

    }

    
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


