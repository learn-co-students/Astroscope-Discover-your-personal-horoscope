
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


let kREACHABILITYWITHWIFI = "ReachableWithWIFI"
let kNOTREACHABLE = "notReachable"
let kREACHABLEWITHWWAN = "ReachableWithWWAN"

var reachability: Reachability?
var reachabilityStatus = kREACHABILITYWITHWIFI



class HoroscopeViewController: UIViewController, KCFloatingActionButtonDelegate, UIGestureRecognizerDelegate {
    
    var imageNASAView = UIImageView()
    var passedHoroscopeString: String?
    
    var signIcon = UIImageView()
    var dailyHoroscopeTextView: UITextView!
    var todaysDateLabel: UILabel!
    var todaysDate: String?
    var APIDate: String?
    var signName: UILabel!
    
    
    var internetReach: Reachability?
    
    var iconsDictionary: [String: String] = ["capricorn": "capricorn_black_parkjisun.png", "aquarius":"aquarius_black_parkjisun.png", "pisces" : "pisces_black_parkjisun.png", "aries" : "aries_black_parkjisun.png", "taurus" : "taurus_black_parkjisun.png", "gemini" : "gemini_black_parkjisun.png", "cancer" : "cancer_black_parkjisun.png", "leo" : "leo_black_parkjisun.png", "virgo" : "virgo_black_parkjisun.png", "libra" : "libra_black_parkjisun.png", "scorpio" : "scorpio_black_parkjisun.png", "sagittarius" : "sagittarius_black_parkjisun.png"]
    
    let tapRecStackView = UITapGestureRecognizer()
    let returnTapRec = UITapGestureRecognizer()
    var viewTapRec = UITapGestureRecognizer()
    
    
    var iconTapRec = UITapGestureRecognizer()
    var isIconTapped: Bool = false
    var horoStackView = UIStackView()
    let stackViewBackgroundView = UIView()
    
    var yesterdaysHoroscope: String?
    var todaysHoroscope: String?
    
    var menuButton = KCFloatingActionButton()

    var stackViewDimed: Bool = false
    let transparentViewButton = UIButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
      
            MenuBarButtons()
            NASAApiPicture()
            allConstraints()
            horoscopeAPICall()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HoroscopeViewController.reachabilityChanged(_:)), name: kReachabilityChangedNotification, object: nil)
        
        internetReach = Reachability.reachabilityForInternetConnection()
        internetReach?.startNotifier()
        
        self.statusChangedWithReachability(internetReach!)
        
        guard let horoscopeString = passedHoroscopeString else {return}
        self.title = horoscopeString.capitalizedString

    }
    
    override func viewDidAppear(animated: Bool) {
        self.stackViewBackgroundView.hidden = false
    }
  
    func statusChangedWithReachability(currentStatus: Reachability)
    {
        let networkStatus: NetworkStatus = currentStatus.currentReachabilityStatus()
        
        print("Status: \(networkStatus.rawValue)")
        
        
        if networkStatus.rawValue == ReachableViaWiFi.rawValue
        {
            
          
        }
        else if networkStatus.rawValue == ReachableViaWWAN.rawValue
        {
        
        }
        else if networkStatus.rawValue == NotReachable.rawValue
        {
            reachabilityStatus = kNOTREACHABLE
            print("Network not reachable")
            
            
            let noNetworkAlertController = UIAlertController(title: "No Network Connection detected", message: "Cannot display Horoscope of the day", preferredStyle: .Alert)
            
            self.presentViewController(noNetworkAlertController, animated: true, completion: nil)
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                    noNetworkAlertController.dismissViewControllerAnimated(true, completion: nil)
                })
            }
            
            
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("reachStatusChanged", object: nil)
    }
    
    func reachabilityChanged(notification: NSNotification)
    {
        print("Reachability status changed")
        reachability = notification.object as? Reachability
        self.statusChangedWithReachability(reachability!)
    }

    
    func toggleStackViewButtonView(sender: UIButton)
    {
        toggleStackView()
        print("Button clicked")
        print(stackViewDimed)
    }
    
    
    
    func allConstraints() {

        let date = NSDate()
        let todaysDateFormat = NSDateFormatter()
        todaysDateFormat.dateFormat = "yyyy-MM-dd"
        todaysDate = todaysDateFormat.stringFromDate(date)
        
        self.stackViewBackgroundView.alpha = 1.0
        view.addSubview(self.stackViewBackgroundView)
        menuButton.fabDelegate = self
        
        view.userInteractionEnabled = true
        menuButton.userInteractionEnabled = true
        
        self.signIcon.clipsToBounds = true
        self.signIcon.tintColor = UIColor.whiteColor()
        self.signName = UILabel()
        self.signName.textAlignment = NSTextAlignment.Center
        self.signName.textColor = UIColor.whiteColor()
        self.signName.font = UIFont(name: "BradleyHandITCTT-Bold", size: 36.0)
        
        
        self.todaysDateLabel = UILabel()
        self.todaysDateLabel.text = self.todaysDate
        self.todaysDateLabel.textAlignment = NSTextAlignment.Center
        self.todaysDateLabel.textColor = UIColor.whiteColor()
        self.todaysDateLabel.font = UIFont(name: "BradleyHandITCTT-Bold", size: 19.0)
        
        
        self.dailyHoroscopeTextView = UITextView()
        self.dailyHoroscopeTextView.selectable = false
        self.dailyHoroscopeTextView.backgroundColor = UIColor.clearColor()
        guard self.dailyHoroscopeTextView != nil else {return}
        self.dailyHoroscopeTextView.textColor = UIColor.whiteColor()
        self.dailyHoroscopeTextView.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        
        
        self.stackViewBackgroundView.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        self.view.addSubview(self.stackViewBackgroundView)
        
        self.stackViewBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        //        self.stackViewBackgroundView.removeConstraints(self.stackViewBackgroundView.constraints)
        self.stackViewBackgroundView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        self.stackViewBackgroundView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor, constant: +6.0).active = true
        self.stackViewBackgroundView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor, multiplier: 0.65).active = true
        self.stackViewBackgroundView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor, multiplier: 0.75).active = true
        
        
        self.horoStackView.axis = .Vertical
        self.horoStackView.distribution = .Fill
        self.horoStackView.alignment = .Center
        self.horoStackView.spacing = 0
        
        self.horoStackView.addArrangedSubview(self.signIcon)
        self.horoStackView.addArrangedSubview(self.signName)
        self.horoStackView.addArrangedSubview(self.todaysDateLabel)
        self.horoStackView.addArrangedSubview(self.dailyHoroscopeTextView)
        
        
        self.stackViewBackgroundView.addSubview(self.horoStackView)
        self.horoStackView.translatesAutoresizingMaskIntoConstraints = false
        //        self.horoStackView.removeConstraints(self.horoStackView.constraints)
        self.horoStackView.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
        self.horoStackView.centerYAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerYAnchor).active = true
        
        self.signIcon.translatesAutoresizingMaskIntoConstraints = false
        //        self.signIcon.removeConstraints(self.signIcon.constraints)
        //        self.signIcon.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
        //        self.signIcon.leadingAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.leadingAnchor).active = true
        //        self.signIcon.trailingAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.trailingAnchor).active = true
        //        self.signIcon.heightAnchor.constraintEqualToAnchor(self.signIcon.widthAnchor).active = true
        
        self.signIcon.widthAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.widthAnchor, multiplier: 0.65).active = true
        self.signIcon.heightAnchor.constraintEqualToAnchor(self.signIcon.widthAnchor).active = true
        //        self.signIcon.image?.
        // self.signIcon.bounds = CGRectInset(self.signIcon.frame, 0.0, -0.10)
        // self.signIcon.frame.size = CGSize(width: 5.0, height: 5.0)
        
        self.signName.translatesAutoresizingMaskIntoConstraints = false
        self.signName.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
        
        
        self.todaysDateLabel.translatesAutoresizingMaskIntoConstraints = false
        //        self.todaysDateLabel.removeConstraints(self.todaysDateLabel.constraints)
        self.todaysDateLabel.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
        
        self.dailyHoroscopeTextView.translatesAutoresizingMaskIntoConstraints = false
        //        self.dailyHoroscopeTextView.removeConstraints(self.dailyHoroscopeTextView.constraints)
        //        self.dailyHoroscopeTextView.centerXAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.centerXAnchor).active = true
        //        self.dailyHoroscopeTextView.heightAnchor.constraintEqualToAnchor(self.stackViewBackgroundView
        //            .widthAnchor, multiplier: 0.90).active = true
        self.dailyHoroscopeTextView.widthAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.widthAnchor, multiplier: 0.90).active = true
        self.dailyHoroscopeTextView.heightAnchor.constraintEqualToAnchor(self.stackViewBackgroundView.heightAnchor, multiplier: 0.45).active = true
        
        
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
    
    
    func isSignIconTapped(isBool : Bool){
        
        if isIconTapped == true {
            
            horoStackView.tintColor = UIColor.whiteColor()
        } else {
            horoStackView.tintColor = UIColor.blackColor()
            
        }
        
    }
    func toggleStackView () {
        
        if stackViewDimed == true {
            
            UIView.animateWithDuration(0.75, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.stackViewBackgroundView.alpha = 0.0
                }, completion: nil)
            
            stackViewDimed = false
            
        }
        else if stackViewDimed == false {
            
            
            UIView.animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.stackViewBackgroundView.alpha = 1.0}, completion: nil)
            
            stackViewDimed = true
            
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for _ in touches {
            
            if let touch = touches.first {
                if CGRectContainsPoint(menuButton.frame, touch.locationInView(self.view)){
                    print(stackViewDimed)
                    
                    
                    
                    if stackViewDimed == false {
                        stackViewDimed = !stackViewDimed
                        view.addSubview(transparentViewButton)
                        
                        self.transparentViewButton.translatesAutoresizingMaskIntoConstraints = false
                        self.transparentViewButton.removeConstraints(self.transparentViewButton.constraints)
                        self.transparentViewButton.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
                        self.transparentViewButton.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
                        self.transparentViewButton.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
                        self.transparentViewButton.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
                        self.transparentViewButton.addTarget(self, action: #selector(HoroscopeViewController.toggleStackViewButtonView(_:)), forControlEvents: .TouchUpInside)
                        
                        
                        UIView.animateWithDuration(0.75, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                            self.stackViewBackgroundView.alpha = 0.0
                            }, completion: nil)
                        
                        
                    }
                    else if stackViewDimed == true {
                        
                        
                        
                        stackViewDimed = !stackViewDimed
                        
                        
                        UIView.animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                            self.stackViewBackgroundView.alpha = 1.0}, completion: nil)
                        
                        
                        stackViewDimed = false
                        
                    }
                    print(stackViewDimed)
                    
                }
            }
        }
        super.touchesBegan(touches, withEvent:event)
    }
      
    func MenuBarButtons() {
        
        menuButton.buttonColor = UIColor.whiteColor()
        
        let savePhotoImage = UIImage.init(named: "savephotobuttonimage.png")
        let goToOtherHoroscopes = UIImage.init(named: "StarOfBethlehem-50.png")
        
        menuButton.addItem("See Other Horoscopes", icon: goToOtherHoroscopes) { (action) in
            
            self.performSegueWithIdentifier("horoscopeToOthers", sender: self)
            
            
        }
        
        
        
        
        
        
        menuButton.addItem("Save NASA Image", icon: savePhotoImage) { (action) in
            
            if let unwrappedImage = self.imageNASAView.image {
                
                UIImageWriteToSavedPhotosAlbum(unwrappedImage, self, nil, nil)
                let savedAlertController = UIAlertController(title: "Image Saved!", message: "", preferredStyle: .Alert)
                
                
                self.presentViewController(savedAlertController, animated: true, completion: nil)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                        savedAlertController.dismissViewControllerAnimated(true, completion: nil)
                savedAlertController.view.backgroundColor = UIColor.blackColor()
                savedAlertController.view.tintColor = UIColor.blackColor()
                
                UIView.animateWithDuration(1.0, delay: 0.5, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.stackViewBackgroundView.alpha = 1.0
                    }, completion: nil)
                self.view.addSubview(self.stackViewBackgroundView)
                self.stackViewDimed = false
                
                
                    })
                }
                
            }
                
            else {
                
                let savedAlertControllerError = UIAlertController(title: "Save error", message: "error", preferredStyle: .Alert)
                savedAlertControllerError.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(savedAlertControllerError, animated: true, completion: nil)
            }
        }
        self.view.addSubview(menuButton)
    }
}