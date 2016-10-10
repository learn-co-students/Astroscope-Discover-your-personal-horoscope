
//  ViewController.swift
//  Lemonade
//
//  Created by Bettina on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Foundation
import CoreData
import AssetsLibrary
import KCFloatingActionButton
import SystemConfiguration


let kREACHABILITYWITHWIFI = "ReachableWithWIFI"
let kNOTREACHABLE = "notReachable"
let kREACHABLEWITHWWAN = "ReachableWithWWAN"

var reachability: Reachability?
var reachabilityStatus = kREACHABILITYWITHWIFI


class HoroscopeViewController: UIViewController, KCFloatingActionButtonDelegate, UIGestureRecognizerDelegate
{
    let button = KCFloatingActionButton()
    
    @IBOutlet weak var colorChangeSlider: UISlider!
    @IBOutlet weak var NASAPhotoTitle: UILabel!
    @IBOutlet weak var horoscopeActIndicator: UIActivityIndicatorView!
    
    var imageNASAView = UIImageView()
    var passedHoroscopeString: String?
    var signIcon = UIImageView()
    var dailyHoroscopeTextView: UITextView!
    var todaysDateLabel: UILabel!
    var todaysDate: String?
    var APIDate: String?
    var signName: UILabel!
    var NASAPhotoInfo : UITextView!
    var backgroundTapped = UIGestureRecognizer()
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
    var viewDimed : Bool = false
    
    let transparentViewButton = UIButton()
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
      
            MenuBarButtons()
            NASAApiPicture()
            allConstraints()
            horoscopeAPICall()
    
    
        NotificationCenter.default.addObserver(self, selector: #selector(HoroscopeViewController.reachabilityChanged(_:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        
        internetReach = Reachability.forInternetConnection()
        internetReach?.startNotifier()
        
        self.statusChangedWithReachability(internetReach!)
        
        guard let horoscopeString = passedHoroscopeString else {return}
        self.title = horoscopeString.capitalized
        
        self.transparentViewButton.isEnabled = false
        self.view.bringSubview(toFront: menuButton)
        self.NASAPhotoInfo.isHidden = true
        self.NASAPhotoTitle.isHidden = true
        
        self.horoscopeActIndicator.isHidden = false
        self.horoscopeActIndicator.startAnimating()
        
        
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(image: UIImage.init(named: "customBackButton.png"), style: .done, target: self, action: #selector (HoroscopeViewController.backButtonPressed))
    

    }


    override func viewDidAppear(_ animated: Bool)
    {
        self.stackViewBackgroundView.isHidden = false
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "BradleyHandITCTT-Bold", size: 21)!]
     
        self.backgroundTapped = UIGestureRecognizer(target: self, action: #selector( HoroscopeViewController.touchesBegan(_:with:)))
    
        self.imageNASAView.addSubview(NASAPhotoInfo)
        self.imageNASAView.addGestureRecognizer(backgroundTapped)
       
    }
    
    func backButtonPressed(sender:UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
    
  
    @IBAction func colorSlider(_ sender: AnyObject)
    {
        
        let colorValue = CGFloat(colorChangeSlider.value)
        let color = UIColor(hue: colorValue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    
        self.colorChangeSlider.minimumTrackTintColor = color
        self.colorChangeSlider.maximumTrackTintColor = color
        self.dailyHoroscopeTextView.textColor = color
        self.NASAPhotoInfo.textColor = color
        self.signIcon.tintColor = color
        self.signName.textColor = color
        self.todaysDateLabel.textColor = color
        self.NASAPhotoTitle.textColor = color
        
        if colorValue == 0
        {
            self.dailyHoroscopeTextView.textColor = UIColor.black
            self.NASAPhotoInfo.textColor = UIColor.black
            self.colorChangeSlider.maximumTrackTintColor = UIColor.black
            self.signIcon.tintColor = UIColor.black
            self.signName.textColor = UIColor.black
            self.todaysDateLabel.textColor = UIColor.black
            self.NASAPhotoTitle.textColor = UIColor.black
        }
        if colorValue == 1
        {
            self.dailyHoroscopeTextView.textColor = UIColor.white
            self.NASAPhotoInfo.textColor = UIColor.white
            self.signIcon.tintColor = UIColor.white
            self.signName.textColor = UIColor.white
            self.colorChangeSlider.minimumTrackTintColor = UIColor.white
            self.todaysDateLabel.textColor = UIColor.white
            self.NASAPhotoTitle.textColor = UIColor.white
        }
    }
    

    func statusChangedWithReachability(_ currentStatus: Reachability)
    {
        let networkStatus: NetworkStatus = currentStatus.currentReachabilityStatus()
        
        print("Status: \(networkStatus.rawValue)")
        
        
        if networkStatus.rawValue == ReachableViaWiFi.rawValue
        {
            horoscopeAPICall()
            NASAApiPicture()
        }
        else if networkStatus.rawValue == ReachableViaWWAN.rawValue
        {
            horoscopeAPICall()
            NASAApiPicture()
        }
        else if networkStatus.rawValue == NotReachable.rawValue
        {
            reachabilityStatus = kNOTREACHABLE
            print("Network not reachable")
            
            
            let noNetworkAlertController = UIAlertController(title: "No Network Connection detected", message: "Cannot display Horoscope of the day", preferredStyle: .alert)
            
            self.present(noNetworkAlertController, animated: true, completion: nil)
            
            DispatchQueue.main.async { () -> Void in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                    noNetworkAlertController.dismiss(animated: true, completion: nil)
                })
            }
            
            
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reachStatusChanged"), object: nil)
    }
    
    func reachabilityChanged(_ notification: Notification)
    {
        print("Reachability status changed")
        reachability = notification.object as? Reachability
        statusChangedWithReachability(reachability!)
    }

    
    func toggleStackViewButtonView(_ sender: UIButton)
    {
        toggleStackView()

        print("Toggled!!!!!")
        print(stackViewDimed)
    }
    
    func allConstraints()
    {

        let date = Date()
        let todaysDateFormat = DateFormatter()
        todaysDateFormat.dateFormat = "yyyy-MM-dd"
        todaysDate = todaysDateFormat.string(from: date)
        
        self.stackViewBackgroundView.alpha = 1.0
        view.addSubview(self.stackViewBackgroundView)
        menuButton.fabDelegate = self
        
        view.isUserInteractionEnabled = true
        menuButton.isUserInteractionEnabled = true
        
        self.signIcon.clipsToBounds = true
        self.signIcon.tintColor = UIColor.white
        self.signName = UILabel()
        self.signName.textAlignment = NSTextAlignment.center
        self.signName.textColor = UIColor.white
        self.signName.font = UIFont(name: "BradleyHandITCTT-Bold", size: 36.0)
        
        
        self.todaysDateLabel = UILabel()
        self.todaysDateLabel.text = self.todaysDate
        self.todaysDateLabel.textAlignment = NSTextAlignment.center
        self.todaysDateLabel.textColor = UIColor.white
        self.todaysDateLabel.font = UIFont(name: "BradleyHandITCTT-Bold", size: 19.0)
        
        
        self.dailyHoroscopeTextView = UITextView()
        self.dailyHoroscopeTextView.isSelectable = false
        self.dailyHoroscopeTextView.backgroundColor = UIColor.clear
        guard self.dailyHoroscopeTextView != nil else {return}
        self.dailyHoroscopeTextView.textColor = UIColor.white
        self.dailyHoroscopeTextView.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        
        self.NASAPhotoInfo = UITextView()
        self.NASAPhotoInfo.isSelectable = false
        self.NASAPhotoInfo.backgroundColor = UIColor.clear
        guard self.NASAPhotoInfo != nil else {return}
        self.NASAPhotoInfo.textColor = UIColor.white
        self.NASAPhotoInfo.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
        
        self.stackViewBackgroundView.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        self.view.addSubview(self.stackViewBackgroundView)
        
        self.stackViewBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.stackViewBackgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.stackViewBackgroundView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: +6.0).isActive = true
        self.stackViewBackgroundView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.65).isActive = true
        self.stackViewBackgroundView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.75).isActive = true
        
        
        self.horoStackView.axis = .vertical
        self.horoStackView.distribution = .fill
        self.horoStackView.alignment = .center
        self.horoStackView.spacing = 0
        
        self.horoStackView.addArrangedSubview(self.signIcon)
        self.horoStackView.addArrangedSubview(self.signName)
        self.horoStackView.addArrangedSubview(self.todaysDateLabel)
        self.horoStackView.addArrangedSubview(self.dailyHoroscopeTextView)
        
        
        self.stackViewBackgroundView.addSubview(self.horoStackView)
        self.horoStackView.translatesAutoresizingMaskIntoConstraints = false
        self.horoStackView.centerXAnchor.constraint(equalTo: self.stackViewBackgroundView.centerXAnchor).isActive = true
        self.horoStackView.centerYAnchor.constraint(equalTo: self.stackViewBackgroundView.centerYAnchor).isActive = true
        
        self.signIcon.translatesAutoresizingMaskIntoConstraints = false
        self.signIcon.widthAnchor.constraint(equalTo: self.stackViewBackgroundView.widthAnchor, multiplier: 0.65).isActive = true
        self.signIcon.heightAnchor.constraint(equalTo: self.signIcon.widthAnchor).isActive = true
        self.signName.translatesAutoresizingMaskIntoConstraints = false
        self.signName.centerXAnchor.constraint(equalTo: self.stackViewBackgroundView.centerXAnchor).isActive = true
        
        
        self.todaysDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.todaysDateLabel.centerXAnchor.constraint(equalTo: self.stackViewBackgroundView.centerXAnchor).isActive = true
        
        self.dailyHoroscopeTextView.translatesAutoresizingMaskIntoConstraints = false
        self.dailyHoroscopeTextView.widthAnchor.constraint(equalTo: self.stackViewBackgroundView.widthAnchor, multiplier: 0.90).isActive = true
        self.dailyHoroscopeTextView.heightAnchor.constraint(equalTo: self.stackViewBackgroundView.heightAnchor, multiplier: 0.45).isActive = true
        
        
        self.view.addSubview(NASAPhotoInfo)
        self.NASAPhotoInfo.translatesAutoresizingMaskIntoConstraints = false
        self.NASAPhotoInfo.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.80).isActive = true
        self.NASAPhotoInfo.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.80).isActive = true
        self.NASAPhotoInfo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.NASAPhotoInfo.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 90.0).isActive = true
    }
    
    
    func horoscopeAPICall()
    {
        
        guard let unwrappedPassedHoroscopeString = self.passedHoroscopeString else {return}
        
        self.signIcon.image = UIImage(named: self.iconsDictionary[unwrappedPassedHoroscopeString]!)
        self.signName.text = unwrappedPassedHoroscopeString.capitalized
        
        
        HoroscopeAPIClient.getAnyDayHoroscope(unwrappedPassedHoroscopeString, day: "today") { (unwrappedZodiac) in
            
            guard let unwrappedHoroscopeDate = unwrappedZodiac["date"] as? String else {return}
            
            guard let unwrappedHoroscopeValue = unwrappedZodiac["horoscope"] as? String else {return}
            
            self.APIDate = unwrappedHoroscopeDate
            
            if self.APIDate == self.todaysDate
            {
                DispatchQueue.main.async(execute: {
                self.todaysHoroscope = unwrappedHoroscopeValue
                self.dailyHoroscopeTextView.text = self.todaysHoroscope
                self.horoscopeActIndicator.isHidden = true
                self.horoscopeActIndicator.stopAnimating()
                })
        
            }
            else if self.APIDate != self.todaysDate
            {
                
                HoroscopeAPIClient.getAnyDayHoroscope(unwrappedPassedHoroscopeString, day: "yesterday") { (unwrappedZodiac) in
                    DispatchQueue.main.async(execute: {
                    guard let unwrappedHoroscopeValue = unwrappedZodiac["horoscope"] as? String else {return}
                    
                    self.yesterdaysHoroscope = unwrappedHoroscopeValue
                    self.dailyHoroscopeTextView.text = self.yesterdaysHoroscope
                        self.horoscopeActIndicator.isHidden = true
                        self.horoscopeActIndicator.stopAnimating()
        
                    })
                    
                }
            }
           
        }
    }
    
    func NASAApiPicture ()
    {
        
        self.view.addSubview(self.imageNASAView)
        self.imageNASAView.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageNASAView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.imageNASAView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.imageNASAView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        self.imageNASAView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.view.sendSubview(toBack: self.imageNASAView)
        
        NASA_API_Client.getMediaType { (mediaType) in
                    
        if mediaType == "video"
        {
            OperationQueue.main.addOperation({ 
                self.imageNASAView.image = UIImage.init(named: "spaceImage4.jpg")
                self.NASAPhotoInfo.text = "No Description Available, Check out NASA's Video of the day!"
                
            })
            
        }
        else
        {
            NASA_API_Client.getPhotoOfDay { (spaceImage) in
                DispatchQueue.main.async(execute: {
                    self.imageNASAView.image = spaceImage
        
                })
            }
            NASA_API_Client.getNASAPhotoInfo({ (dictionary) in
                DispatchQueue.main.async(execute: { 
                    let info = dictionary["explanation"] as! String
                    let title = dictionary["title"] as! String
                
                    self.NASAPhotoTitle.text = title
                    self.NASAPhotoInfo.text = info
                })
              
            })
         
            
        }
        
        }
        
        
    }
    
    
    func isSignIconTapped(_ isBool : Bool){
        
        if isIconTapped == true
        {
            horoStackView.tintColor = UIColor.white
        }
        else
        {
            horoStackView.tintColor = UIColor.black
        }
        
    }
    func toggleStackView ()
    {
        if stackViewDimed == true
        {
            self.NASAPhotoInfo.isHidden = true
            self.NASAPhotoTitle.isHidden = true
            print("toggled")
            UIView.animate(withDuration: 0.75, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.stackViewBackgroundView.alpha = 0.0
                }, completion: nil)
            
            stackViewDimed = false
            
        }
        else if stackViewDimed == false
        {
        
            UIView.animate(withDuration: 1.0, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.stackViewBackgroundView.alpha = 1.0}, completion: nil)
            
            stackViewDimed = true
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        print("pressed?")
        print(stackViewDimed)
        if stackViewDimed == false
        {
            stackViewDimed = !stackViewDimed
            view.addSubview(transparentViewButton)
                        
            self.NASAPhotoInfo.isHidden = false
            self.NASAPhotoTitle.isHidden = false
           // self.colorChangeSlider.isHidden = false
            
            UIView.animate(withDuration: 0.75, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.stackViewBackgroundView.alpha = 0.0
                }, completion: nil)
            
        }
        else if stackViewDimed == true
        {
            stackViewDimed = !stackViewDimed
                        
            self.NASAPhotoInfo.isHidden = true
            self.NASAPhotoTitle.isHidden = true
           // self.colorChangeSlider.isHidden = true
                    
            UIView.animate(withDuration: 1.0, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.stackViewBackgroundView.alpha = 1.0}, completion: nil)
                stackViewDimed = false
        }
        print(stackViewDimed)
        
    }
    
  
    func MenuBarButtons()
    {
        menuButton.buttonColor = UIColor.white
        
        let savePhotoImage = UIImage.init(named: "savephotobuttonimage.png")
        let goToOtherHoroscopes = UIImage.init(named: "StarOfBethlehem-50.png")
        
        menuButton.addItem("See Other Horoscopes", icon: goToOtherHoroscopes) { (action) in
            
            self.performSegue(withIdentifier: "horoscopeToOthers", sender: self)
        }
        
        
        menuButton.addItem("Save NASA Image", icon: savePhotoImage) { (action) in
            
            if let unwrappedImage = self.imageNASAView.image
            {
                UIImageWriteToSavedPhotosAlbum(unwrappedImage, self, nil, nil)
                let savedAlertController = UIAlertController(title: "Image Saved!", message: "", preferredStyle: .alert)
                
                
                self.present(savedAlertController, animated: true, completion: nil)
                DispatchQueue.main.async { () -> Void in
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
                        savedAlertController.dismiss(animated: true, completion: nil)
                        savedAlertController.view.backgroundColor = UIColor.black
                        savedAlertController.view.tintColor = UIColor.black
                
                        UIView.animate(withDuration: 1.0, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations:{
                            self.stackViewBackgroundView.alpha = 1.0
                            }, completion: nil)
                        self.view.addSubview(self.stackViewBackgroundView)
                        self.stackViewDimed = false
                        self.NASAPhotoTitle.isHidden = true
                        self.NASAPhotoInfo.isHidden = true
            
                    })
                }
                
            }
                
            else
            {
                
                let savedAlertControllerError = UIAlertController(title: "Save error", message: "error", preferredStyle: .alert)
                savedAlertControllerError.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(savedAlertControllerError, animated: true, completion: nil)
            }
        }
        
        NASA_API_Client.getMediaType { (mediaType) in
            if mediaType == "video"
            {
                DispatchQueue.main.async(execute: { 
                    self.menuButton.addItem("NASA's Video of the day", icon: UIImage.init(named: "movieTemp.png"), handler: { (action) in
                            self.performSegue(withIdentifier: "videoSegue", sender: self)
                    })
                })
               
            }
            else
            {
                //nothing
            }
        }
        self.view.addSubview(menuButton)

    }


}

