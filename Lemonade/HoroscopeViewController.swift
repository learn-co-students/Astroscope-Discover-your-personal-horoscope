
//  ViewController.swift
//  Lemonade
//
//  Created by Flatiron School on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData
import AssetsLibrary
import KCFloatingActionButton
import SystemConfiguration

class HoroscopeViewController: UIViewController {
    
    var imageNASAView = UIImageView()
    var passedHoroscopeString: String?
    
    var signIcon = UIImageView ()
    var dailyHoroscopeTextView: UITextView!
    var todaysDate: UILabel!
    var signName: UILabel!
    var iconsDictionary: [String: String] = ["Capricorn": "capricorn_black_parkjisun.png", "Aquarius":"aquarius_black_parkjisun.png", "Pisces" : "pisces_black_parkjisun.png", "Aries" : "aries_black_parkjisun.png", "Taurus" : "taurus_black_parkjisun.png", "Gemini" : "gemini_black_parkjisun.png", "Cancer" : "cancer_black_parkjisun.png", "Leo" : "leo_black_parkjisun.png", "Virgo" : "virgo_black_parkjisun.png", "Libra" : "libra_black_parkjisun.png", "Scorpio" : "scorpio_black_parkjisun.png", "Sagittarius" : "sagittarius_black_parkjisun.png"]
    let tapRecStackView = UITapGestureRecognizer()
    let returnTapRec = UITapGestureRecognizer()
    var iconTapRec = UITapGestureRecognizer()
    var isIconTapped: Bool = false
    var isBlurred: Bool = false
    var horoStackView = UIStackView()
    let stackViewBackgroundView = UIView()
    var saveNASAImageToCameraRollButton = UIButton()
    var menuButton = KCFloatingActionButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noInternetConnectionAlert()
        NASAPic()
        horoscopeStackViewsAndTextViewsAndImageViews()
        MenuBarButtons()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for obj in touches {
            
            
            if let touch = touches.first {
                if CGRectContainsPoint(menuButton.frame, touch.locationInView(self.view)){
                    self.stackViewBackgroundView.hidden = !self.stackViewBackgroundView.hidden
                }
            }
            super.touchesBegan(touches, withEvent:event)
        }
    }
    
    func noInternetConnectionAlert () {
        
        if Reachability.isConnectedToNetwork() == true {
        } else {
            let noInternetAlertController = UIAlertController(title: "", message: "No Internet Connection", preferredStyle: .Alert)
            noInternetAlertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(noInternetAlertController, animated: true, completion: nil)
            noInternetAlertController.view.backgroundColor = UIColor.blackColor()
            noInternetAlertController.view.tintColor = UIColor.blackColor()
        }
    }
    
    func MenuBarButtons() {
        
        menuButton.buttonColor = UIColor.whiteColor()
        
        let savePhotoImage = UIImage.init(named: "savephotobuttonimage.png")
        
        menuButton.addItem("Save NASA Image", icon: savePhotoImage) { (action) in
            
            if let unwrappedImage = self.imageNASAView.image {
                
                UIImageWriteToSavedPhotosAlbum(unwrappedImage, self, nil, nil)
                let savedAlertController = UIAlertController(title: "", message: "Saved!", preferredStyle: .Alert)
                savedAlertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(savedAlertController, animated: true, completion: nil)
                savedAlertController.view.backgroundColor = UIColor.blackColor()
                savedAlertController.view.tintColor = UIColor.blackColor()
            
            }
                
            else {
                
                let savedAlertControllerError = UIAlertController(title: "Save error", message: "error", preferredStyle: .Alert)
                savedAlertControllerError.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(savedAlertControllerError, animated: true, completion: nil)
                
            }
            
        }
       
        self.view.addSubview(menuButton)
    }
    
    func NASAPic () {
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
    }
    
    func horoscopeStackViewsAndTextViewsAndImageViews () {
        
        guard let unwrappedPassedHoroscopeString = self.passedHoroscopeString else {return}
        HoroscopeAPIClient.getDailyHoroscope(unwrappedPassedHoroscopeString) { (unwrappedZodiac) in
            NSOperationQueue.mainQueue().addOperationWithBlock({
                
                for iconKey in self.iconsDictionary.keys {
                    
                    if iconKey == unwrappedPassedHoroscopeString {
                        
                        self.signIcon.clipsToBounds = true
                        self.signIcon.image = UIImage(named: self.iconsDictionary[iconKey]!)
                        self.signIcon.tintColor = UIColor.whiteColor()
                        self.signIcon.userInteractionEnabled = true
                        self.signIcon.addGestureRecognizer(self.iconTapRec)
                        self.signIcon.translatesAutoresizingMaskIntoConstraints = false
                        
                        guard let unwrappedSignName = unwrappedZodiac["sunsign"] as? String else {return}
                        
                        self.signName = UILabel()
                        guard self.signName != nil else {return}
                        self.signName.text = unwrappedSignName
                        self.signName.textAlignment = NSTextAlignment.Center
                        self.signName.textColor = UIColor.whiteColor()
                        self.signName.font = UIFont(name: "BradleyHandITCTT-Bold", size: 35.0)
                        guard let unwrappedTodaysDate = unwrappedZodiac["date"] as? String else {return}
                        self.todaysDate = UILabel()
                        
                        guard self.todaysDate != nil else {return}
                        
                        self.todaysDate.text = unwrappedTodaysDate
                        self.todaysDate.textAlignment = NSTextAlignment.Center
                        self.todaysDate.textColor = UIColor.whiteColor()
                        self.todaysDate.font = UIFont(name: "BradleyHandITCTT-Bold", size: 18.0)
                        
                        print(unwrappedTodaysDate)
                        
                        
                        guard let unwrappedHoroscopeValue = unwrappedZodiac["horoscope"] as? String else {return}
                        
                        self.dailyHoroscopeTextView = UITextView()
                        self.dailyHoroscopeTextView.backgroundColor = UIColor.clearColor()
                        guard self.dailyHoroscopeTextView != nil else {return}
                        self.dailyHoroscopeTextView.text = unwrappedHoroscopeValue
                        self.dailyHoroscopeTextView.textColor = UIColor.whiteColor()
                        self.dailyHoroscopeTextView.font = UIFont(name: "BradleyHandITCTT-Bold", size: 18.0)
                        
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
                        self.horoStackView.addArrangedSubview(self.todaysDate)
                        self.horoStackView.addArrangedSubview(self.dailyHoroscopeTextView)
                        
                        self.stackViewBackgroundView.addSubview(self.horoStackView)
                        
                        self.signIcon.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
                        self.signIcon.widthAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.widthAnchor, multiplier: 0.65).active = true
                        self.signIcon.heightAnchor.constraintEqualToAnchor(self.signIcon.widthAnchor).active = true
                        
                        self.signName.widthAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.widthAnchor).active = true
                        self.signName.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
                        self.todaysDate.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
                        
                        self.dailyHoroscopeTextView.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
                        self.dailyHoroscopeTextView.widthAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.widthAnchor, multiplier: 0.90).active = true
                        self.dailyHoroscopeTextView.heightAnchor.constraintEqualToAnchor(self.dailyHoroscopeTextView.widthAnchor).active = true
                        
                        
                        self.horoStackView.translatesAutoresizingMaskIntoConstraints = false
                        self.horoStackView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
                        self.horoStackView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
                        
                        self.stackViewBackgroundView.userInteractionEnabled = true
                        self.horoStackView.userInteractionEnabled = true
                        
                        self.stackViewBackgroundView.addGestureRecognizer(self.tapRecStackView)
                        self.horoStackView.addGestureRecognizer(self.tapRecStackView)
                        
                        self.stackViewBackgroundView.addGestureRecognizer(self.returnTapRec)
                        self.horoStackView.addGestureRecognizer(self.returnTapRec)
                    }
                }
            })
        }
        
        func stackViewTapped(isBool: Bool){
            
            
            if !UIAccessibilityIsReduceTransparencyEnabled(){
                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                
                if isBlurred == false {
                    
                    blurEffectView.frame = self.view.bounds
                    blurEffectView.autoresizingMask = .FlexibleWidth
                    blurEffectView.autoresizingMask = .FlexibleHeight
                    
                    self.view.addSubview(blurEffectView)
                    
                    horoStackView.hidden = false
                    self.stackViewBackgroundView.hidden = false
                    
                    view.bringSubviewToFront(horoStackView)
                    
                    isBlurred = true
                    
                } else if returnTapRec.enabled == true {
                    
                    if isBlurred == true {
                        
                        horoStackView.hidden = true
                        self.stackViewBackgroundView.hidden = true
                        
                        for subview in view.subviews{
                            if subview is UIVisualEffectView{
                                subview.removeFromSuperview()
                            }
                            
                        }
                        
                    }
                }
            }
            
        }
        func isSignIconTapped(isBool : Bool){
            
            if isIconTapped == true {
                
                horoStackView.tintColor = UIColor.whiteColor()
            } else {
                horoStackView.tintColor = UIColor.blackColor()
            }
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}