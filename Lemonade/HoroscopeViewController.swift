
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
    @IBOutlet weak var constellationInfoTextView: UITextView!
    
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
    var constellationTextDimed : Bool = true
    
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
        self.constellationInfoTextView.isHidden = true
        
        self.horoscopeActIndicator.isHidden = false
        self.horoscopeActIndicator.startAnimating()
        
        
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(image: UIImage.init(named: "customBackButton.png"), style: .done, target: self, action: #selector (HoroscopeViewController.backButtonPressed))
        
    

        setConstellationInfo()
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
    
    func getConstellationInfo()
    {
    
        self.view.removeConstraints(self.constellationInfoTextView.constraints)
        self.constellationInfoTextView.translatesAutoresizingMaskIntoConstraints = false
        
        let navHeight = self.navigationController?.navigationBar.frame.size.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        guard let navBarHeight = navHeight else {return}
        
        print(constellationTextDimed)
        if constellationTextDimed == false
        {
            constellationTextDimed = !constellationTextDimed
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.constellationInfoTextView.alpha = 0.0
                }, completion: nil)
            
        }
        else if constellationTextDimed == true
        {
            constellationTextDimed = !constellationTextDimed
         
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                
                self.constellationInfoTextView.isHidden = false
                self.constellationInfoTextView.heightAnchor.constraint(equalToConstant: 200 + navBarHeight + statusBarHeight).isActive = true
                self.constellationInfoTextView.widthAnchor.constraint(equalToConstant: 250).isActive = true
                self.constellationInfoTextView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: navBarHeight + statusBarHeight).isActive = true
                self.constellationInfoTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -40).isActive = true
                
                self.constellationInfoTextView.alpha = 1.0
                self.view.bringSubview(toFront: self.constellationInfoTextView)
                }, completion: nil)
            
            constellationTextDimed = false
        }
    
    }

    func setConstellationInfo()
    {
        
        if passedHoroscopeString == "sagittarius"
        {
            self.constellationInfoTextView.text = "Sagittarians have a positive outlook on life, are full of enterprise, energy, versatility, adventurousness and eagerness to extend experience beyond the physically familiar. They enjoy travelling and exploration, the more so because their minds are constantly open to new dimensions of thought. They are basically ambitious and optimistic, and continue to be so even when their hopes are dashed. Their strongly idealistic natures can also suffer many disappointments without being affected. They are honorable, honest, trustworthy, truthful, generous and sincere, with a passion for justice. They are usually on the side of the underdog in society they will fight for any cause they believe to be just, and are prepared to be rebellious. They balance loyalty with independence."
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "sagittariusRightButton.png"), style: .done, target: self, action: #selector(HoroscopeViewController.getConstellationInfo))
        }
        else if passedHoroscopeString == "capricorn"
        {
            self.constellationInfoTextView.text = "The sign Capricorn is one of the most stable and (mostly) serious of the zodiacal types. These independent, rocklike characters have many sterling qualities. They are normally confident, strong willed and calm. These hardworking, unemotional, shrewd, practical, responsible, persevering, and cautious to the extreme persons, are capable of persisting for as long as is necessary to accomplish a goal they have set for themselves. Capricorn are reliable workers in almost any profession they undertake. They are the major finishers of most projects started by the 'pioneering' signs; with firm stick-to-it-ness they quickly become the backbone of any company they work for."
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "capricornRightButton.png"), style: .done, target: self, action: #selector(HoroscopeViewController.getConstellationInfo))
        }
        else if passedHoroscopeString == "aquarius"
        {
            self.constellationInfoTextView.text = "Aquarians basically possess strong and attractive personalities. They fall into two principle types: one shy, sensitive, gentle and patient; the other exuberant, lively and exhibitionist, sometimes hiding the considerable depths of their character under a cloak of frivolity. Both types are strong willed and forceful in their different ways and have strong convictions, though as they seek truth above all things, they are usually honest enough to change their opinions, however firmly held, if evidence comes to light which persuades them that they have been mistaken. They have a breadth of vision that brings diverse factors into a whole, and can see both sides of an argument without shilly-shallying as to which side to take. Consequently they are unprejudiced and tolerant of other points of view. This is because they can see the validity of the argument, even if they do not accept it themselves. They obey the Quaker exhortation to \"Be open to truth, from whatever source it comes,\"and are prepared to learn from everyone."
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "aquariusRightButton.png"), style: .done, target: self, action: #selector(HoroscopeViewController.getConstellationInfo))
        }
        else if passedHoroscopeString == "pisces"
        {
            self.constellationInfoTextView.text = "Pisceans possess a gentle, patient, malleable nature. They have many generous qualities and are friendly, good natured, kind and compassionate, sensitive to the feelings of those around them, and respond with the utmost sympathy and tact to any suffering they encounter. They are deservedly popular with all kinds of people, partly because their easygoing, affectionate, submissive natures offer no threat or challenge to stronger and more exuberant characters. They accept the people around them and the circumstances in which they find themselves rather than trying to adapt them to suit themselves, and they patiently wait for problems to sort themselves out rather than take the initiative in solving them. They are more readily concerned with the problems of others than with their own."
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "piscesRightButton.png"), style: .done, target: self, action: #selector(HoroscopeViewController.getConstellationInfo))
        }
        else if passedHoroscopeString == "aries"
        {
            self.constellationInfoTextView.text = "The spring equinox, March 21, is the beginning of the new zodiacal year and Aries, the first sign, is therefore that of new beginnings. The young ram is adventurous, ambitious, impulsive, enthusiastic and full of energy. The Arian is a pioneer both in thought and action, very open to new ideas and a lover of freedom. They welcome challenges and will not be diverted from their purpose except by their own impatience, which will surface if they don't get quick results."
            
           self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "ariesRightButton.png"), style: .done, target: self, action: #selector(HoroscopeViewController.getConstellationInfo))
        }
        else if passedHoroscopeString == "taurus"
        {
            self.constellationInfoTextView.text = "The characteristics of taurus are solidity, practicality, extreme determination and strength of will - no one will ever drive them, but they will willingly and loyally follow a leader they trust. They are stable, balanced, conservative good, law-abiding citizens and lovers of peace, possessing all the best qualities of the bourgeoisie. As they have a sense of material values and physical possessions, respect for property and a horror of falling into debt, they will do everything in their power to maintain the security of the status quo and be somewhat hostile to change."
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "taurusRightButton.png"), style: .done, target: self, action: #selector(HoroscopeViewController.getConstellationInfo))
        }
        else if passedHoroscopeString == "gemini"
        {
            self.constellationInfoTextView.text = "Gemini, the sign of the Twins, is dual-natured, elusive, complex and contradictory. On the one hand it produces the virtue of versatility, and on the other the vices of two-facedness and flightiness. The sign is linked with Mercury, the planet of childhood and youth, and its subjects tend to have the graces and faults of the young. When they are good, they are very attractive; when they are bad they are more the worse for being the charmers they are. Like children they are lively, and happy, if circumstances are right for them, or egocentric, imaginative and restless. They take up new activities enthusiastically but lack application, constantly needing new interests, flitting from project to project as apparently purposelessly as a butterfly dancing from flower to flower. To them life is a game which must always be full of fresh moves and continuous entertainment, free of labor and routine. Changing horses in the middle of the stream is another small quirk in the Gemini personality which makes decision making, and sticking to a decision, particularly hard for them."
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "geminiRightButton.png"), style: .done, target: self, action: #selector(HoroscopeViewController.getConstellationInfo))
        }
        else if passedHoroscopeString == "cancer"
        {
            self.constellationInfoTextView.text = "The Cancerian character is the least clear-cut of all those associated with the signs of the zodiac. It can range from the timid, dull, shy and withdrawn to the most brilliant, and famous Cancerians are to be found through the whole range of human activity. It is a fundamentally conservative and home-loving nature, appreciating the nest like quality of a secure base to which the male can retire when he needs a respite from the stresses of life, and in which the Cancerian woman can exercise her strong maternal instincts. The latter tends to like and to have a large family. `Nest like' is an appropriate adjective for the Cancerian home, for its inhabitants tend to favor the dark, mysterious but comfortable type of house which has something of the air of a den about it, a place which belongs to the family rather than existing as a showcase to impress visitors."
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "cancerRightButton.png"), style: .done, target: self, action: #selector(HoroscopeViewController.getConstellationInfo))
        }
        else if passedHoroscopeString == "leo"
        {
            self.constellationInfoTextView.text = "The Leo type is the most dominant, spontaneously creative and extrovert of all the zodiacal characters. In grandeur of manner, splendor of bearing and magnanimity of personality, they are the monarch's among humans as the lion is king of beasts. They are ambitious, courageous, dominant, strong willed, positive, independent, self-confident there is no such a word as doubt in their vocabularies, and they are self-controlled. Born leaders, either in support of, or in revolt against, the status quo. They are at their most effective when in a position of command, their personal magnetism and innate courtesy of mind bringing out the best of loyalty from subordinates. They are uncomplicated, knowing exactly what they want and using all their energies, creativeness and resolution to get it, as well as being certain that they will get whatever they are after. Their followers know where they are with Leonians. Leonians think and act bigger than others would normally dare; the ambitiousness of their schemes and idealism sometimes daunt their followers, their practical hardheadedness and ability to go straight to the heart of any problem reassures those who depend on them. If Leonians meet with setbacks they thrive on the adversity."
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "leoRightButton.png"), style: .done, target: self, action: #selector(HoroscopeViewController.getConstellationInfo))
        }
        else if passedHoroscopeString == "virgo"
        {
            self.constellationInfoTextView.text = "Virgo is the only zodiacal sign represented by a female. It is sometimes thought of as a potentially creative girl, delicately lovely; sometimes as a somewhat older woman, intelligent but rather pedantic and spinsterish. The latter impression is sometimes confirmed by the Virgoan preciseness, refinement, fastidious love of cleanliness, hygiene and good order, conventionality and aristocratic attitude of reserve. They are usually observant, shrewd, critically inclined, judicious, patient, practical supporters of the status quo, and tend toward conservatism in all departments of life. On the surface they are emotionally cold, and sometimes this goes deeper, for their habit of suppressing their natural kindness may in the end cause it to atrophy, with the result that they shrink from committing themselves to friendship, make few relationships, and those they do make they are careful to keep superficial."
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "virgoRightButton.png"), style: .done, target: self, action: #selector(HoroscopeViewController.getConstellationInfo))
        }
        else if passedHoroscopeString == "libra"
        {
            self.constellationInfoTextView.text = "Libra is the only inanimate sign of the zodiac, all the others representing either humans or animals. Many modern astrologers regard it as the most desirable of zodiacal types because it represents the zenith of the year, the high point of the seasons, when the harvest of all the hard work of the spring is reaped. There is a mellowness and sense of relaxation in the air as mankind enjoys the last of the summer sun and the fruits of his toil. Librans too are among the most civilized of the twelve zodiacal characters and are often good looking. They have elegance, charm and good taste, are naturally kind, very gentle, and lovers of beauty, harmony (both in music and social living) and the pleasures that these bring."
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "libraRightButton.png"), style: .done, target: self, action: #selector(HoroscopeViewController.getConstellationInfo))
        }
        else if passedHoroscopeString == "scorpio"
        {
            self.constellationInfoTextView.text = "Scorpios are the most intense, profound, powerful characters in the zodiac. Even when they appear self-controlled and calm there is a seething intensity of emotional energy under the placid exterior. They are like the volcano not far under the surface of a calm sea, it may burst into eruption at any moment. But those of us who are particularly perceptive will be aware of the harnessed aggression, the immense forcefulness, magnetic intensity, and often strangely hypnotic personality under the tranquil, but watchful composure of Scorpio. In conventional social gatherings they are pleasant to be with, thoughtful in conversation, dignified, and reserved, yet affable and courteous; they sometimes possess penetrating eyes which make their shyer companions feel naked and defenseless before them."
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.init(named: "scorpioRightButton.png"), style: .done, target: self, action: #selector(HoroscopeViewController.getConstellationInfo))
        }
        
    }
    
    func toggleStackViewButtonView(_ sender: UIButton)
    {
        toggleStackView()

        print("Toggled!!!!")
      //  print(stackViewDimed)
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
        self.NASAPhotoInfo.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        
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
        self.NASAPhotoInfo.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.70).isActive = true
        self.NASAPhotoInfo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.NASAPhotoInfo.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: +65.0).isActive = true
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
                
                    if unwrappedHoroscopeValue == "[]"
                    {
                        self.dailyHoroscopeTextView.text = "Horoscope unavailable at this time. We're sorry for the inconvenience and Please check back later."
                    }
                    else
                    {
                        self.todaysHoroscope = unwrappedHoroscopeValue
                         self.dailyHoroscopeTextView.text = self.todaysHoroscope
                    }
                    
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
                
                        if unwrappedHoroscopeValue == "[]"
                        {
                            self.dailyHoroscopeTextView.text = "Horoscope unavailable at this time. We're sorry for the inconvenience and Please check back later."
                        }
                        else
                        {
                            self.dailyHoroscopeTextView.text = self.yesterdaysHoroscope
                        }
                        
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
        if stackViewDimed == false
        {
            stackViewDimed = !stackViewDimed
            view.addSubview(transparentViewButton)
                        
            self.NASAPhotoInfo.isHidden = false
            self.NASAPhotoTitle.isHidden = false
            self.constellationInfoTextView.isHidden = true
            
            UIView.animate(withDuration: 0.75, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.stackViewBackgroundView.alpha = 0.0
                }, completion: nil)
            
        }
        else if stackViewDimed == true
        {
            stackViewDimed = !stackViewDimed
                        
            self.NASAPhotoInfo.isHidden = true
            self.NASAPhotoTitle.isHidden = true
            self.constellationInfoTextView.isHidden = true
                    
            UIView.animate(withDuration: 1.0, delay: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.stackViewBackgroundView.alpha = 1.0}, completion: nil)
                stackViewDimed = false
        }
       
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

