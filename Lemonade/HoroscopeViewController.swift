
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
    
    var signIcon = UIImageView()
    var dailyHoroscopeTextView: UITextView!
    var todaysDateLabel: UILabel!
    var todaysDate: String?
    var APIDate: String?
    var signName: UILabel!
    
    var iconsDictionary: [String: String] = ["capricorn": "capricorn_black_parkjisun.png", "aquarius":"aquarius_black_parkjisun.png", "pisces" : "pisces_black_parkjisun.png", "aries" : "aries_black_parkjisun.png", "taurus" : "taurus_black_parkjisun.png", "gemini" : "gemini_black_parkjisun.png", "cancer" : "cancer_black_parkjisun.png", "leo" : "leo_black_parkjisun.png", "virgo" : "virgo_black_parkjisun.png", "libra" : "libra_black_parkjisun.png", "scorpio" : "scorpio_black_parkjisun.png", "sagittarius" : "sagittarius_black_parkjisun.png"]
    
    let tapRecStackView = UITapGestureRecognizer()
    let returnTapRec = UITapGestureRecognizer()
    
    var iconTapRec = UITapGestureRecognizer()
    var isIconTapped: Bool = false
    var isBlurred: Bool = false
    var horoStackView = UIStackView()
    let stackViewBackgroundView = UIView()
    
    var yesterdaysHoroscope: String?
    var todaysHoroscope: String?
    var saveNASAImageToCameraRollButton = UIButton()
    var menuButton = KCFloatingActionButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        noInternetConnectionAlert()
        MenuBarButtons()
        NASAApiPicture()
        allConstraints()
        horoscopeAPICall()
        
        let date = NSDate()
        let todaysDateFormat = NSDateFormatter()
        todaysDateFormat.dateFormat = "yyyy-MM-dd"
        todaysDate = todaysDateFormat.stringFromDate(date)
        
    }
    
    func allConstraints() {
        self.signIcon.clipsToBounds = true
        self.signIcon.tintColor = UIColor.whiteColor()
        self.signName = UILabel()
        self.signName.textAlignment = NSTextAlignment.Center
        self.signName.textColor = UIColor.whiteColor()
        self.signName.font = UIFont(name: "BradleyHandITCTT-Bold", size: 35.0)
        
        
        self.todaysDateLabel = UILabel()
        self.todaysDateLabel.text = self.todaysDate
        self.todaysDateLabel.textAlignment = NSTextAlignment.Center
        self.todaysDateLabel.textColor = UIColor.whiteColor()
        self.todaysDateLabel.font = UIFont(name: "BradleyHandITCTT-Bold", size: 18.0)
        
        
        self.dailyHoroscopeTextView = UITextView()
        self.dailyHoroscopeTextView.selectable = false
        self.dailyHoroscopeTextView.backgroundColor = UIColor.clearColor()
        guard self.dailyHoroscopeTextView != nil else {return}
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
        self.horoStackView.spacing = 0
        
        self.horoStackView.addArrangedSubview(self.signIcon)
        self.horoStackView.addArrangedSubview(self.signName)
        self.horoStackView.addArrangedSubview(self.todaysDateLabel)
        self.horoStackView.addArrangedSubview(self.dailyHoroscopeTextView)
        
        self.horoStackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackViewBackgroundView.addSubview(self.horoStackView)
        
        self.horoStackView.removeConstraints(self.horoStackView.constraints)
        self.horoStackView.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
        self.horoStackView.centerYAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerYAnchor).active = true
        
        self.signIcon.translatesAutoresizingMaskIntoConstraints = false
        self.signIcon.removeConstraints(self.signIcon.constraints)
        self.signIcon.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
        self.signIcon.leadingAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.leadingAnchor, constant: 10).active = true
        self.signIcon.trailingAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.trailingAnchor, constant: -10).active = true
        self.signIcon.heightAnchor.constraintEqualToAnchor(self.signIcon.widthAnchor).active = true
        self.signIcon.bounds = CGRectInset(self.signIcon.frame, 0.0, -1.50)
        
        self.signName.translatesAutoresizingMaskIntoConstraints = false
        self.signName.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
        
        
        self.todaysDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.todaysDateLabel.removeConstraints(self.todaysDateLabel.constraints)
        self.todaysDateLabel.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
        
        self.dailyHoroscopeTextView.translatesAutoresizingMaskIntoConstraints = false
        self.dailyHoroscopeTextView.removeConstraints(self.dailyHoroscopeTextView.constraints)
        self.dailyHoroscopeTextView.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
        self.dailyHoroscopeTextView.heightAnchor.constraintEqualToAnchor(self.stackViewBackgroundView
            .widthAnchor, multiplier: 0.90).active = true
        
    }
    
    
    func horoscopeAPICall(){
        
        guard let unwrappedPassedHoroscopeString = self.passedHoroscopeString else {return}
        
        self.signIcon.image = UIImage(named: self.iconsDictionary[unwrappedPassedHoroscopeString]!)
        self.signName.text = unwrappedPassedHoroscopeString.capitalizedString
        
        
        HoroscopeAPIClient.getAnyDayHoroscope(unwrappedPassedHoroscopeString, day: "today") { (unwrappedZodiac) in
            guard let unwrappedHoroscopeDate = unwrappedZodiac["date"] as? String else {return}
            
            
            guard let unwrappedHoroscopeValue = unwrappedZodiac["horoscope"] as? String else {return}
            
            self.APIDate = unwrappedHoroscopeDate
            
            if self.APIDate == self.todaysDate {
                
                self.todaysHoroscope = unwrappedHoroscopeValue
                
                NSOperationQueue.mainQueue().addOperationWithBlock{(
                    
                    
                    self.dailyHoroscopeTextView.text = self.todaysHoroscope
                    
                    )}
                
            } else if self.APIDate != self.todaysDate {
                
                HoroscopeAPIClient.getAnyDayHoroscope(unwrappedPassedHoroscopeString, day: "yesterday") { (unwrappedZodiac) in
                    
                    guard let unwrappedHoroscopeValue = unwrappedZodiac["horoscope"] as? String else {return}
                    
                    self.yesterdaysHoroscope = unwrappedHoroscopeValue
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock{(
                        
                        self.dailyHoroscopeTextView.text = self.yesterdaysHoroscope
                        )}
                }
            }
        }
    }
    func NASAApiPicture () {
        
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
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}