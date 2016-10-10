//
//  ZodiacSignsViewController.swift
//  Lemonade
//
//  Created by Bettina on 8/30/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//


import UIKit


private let reuseIdentifier = "collectionCell"

class ZodiacSignsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var collectionView: UICollectionView!
    
    let iconsArray: [String] = ["capricorn_black_parkjisun", "aquarius_black_parkjisun",  "pisces_black_parkjisun", "aries_black_parkjisun", "taurus_black_parkjisun", "gemini_black_parkjisun", "cancer_black_parkjisun",  "leo_black_parkjisun", "virgo_black_parkjisun",  "libra_black_parkjisun", "scorpio_black_parkjisun", "sagittarius_black_parkjisun"]
    
    let iconsDictionary: [String: String] = [ "capricorn_black_parkjisun" : "capricorn", "aquarius_black_parkjisun" : "aquarius", "pisces_black_parkjisun": "pisces", "aries_black_parkjisun" : "aries", "taurus_black_parkjisun": "taurus", "gemini_black_parkjisun" : "gemini", "cancer_black_parkjisun": "cancer", "leo_black_parkjisun": "leo","virgo_black_parkjisun" : "virgo", "libra_black_parkjisun" : "libra", "scorpio_black_parkjisun" : "scorpio", "sagittarius_black_parkjisun" : "sagittarius"]
    
    
    var passedHoroscopeString: String?
    var imageNASAView = UIImageView()
    var collectionViewHoroscopeString = ""
    
    @IBOutlet weak var iconArtist: UILabel!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        NASAApiPicture()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let xInset: CGFloat = 10
        let yInset: CGFloat = 20
        let padding: CGFloat = 10
        let navBarHeight = self.navigationController?.navigationBar.frame.size.height
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let collectionViewCenterYConstant = ((navBarHeight! + statusBarHeight) / 2) + yInset + padding
        
        layout.sectionInset = UIEdgeInsets(top: yInset, left: xInset, bottom: yInset, right: xInset)
        //layout.itemSize = CGSizeMake( 80, 80)
        
        collectionView = UICollectionView(frame: self.imageNASAView.frame, collectionViewLayout: layout)
        // collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        
        collectionView.backgroundColor = UIColor(white: 0.1, alpha: 0.0)
        self.view.addSubview(collectionView)
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.collectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: collectionViewCenterYConstant).isActive = true
        self.collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75).isActive = true
        self.collectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.85).isActive = true
        
        self.collectionView.allowsSelection = true
        
        self.title = "Other Horoscopes"
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(ZodiacSignsViewController.goBackToHomepage))
        
        self.view.bringSubview(toFront: self.iconArtist)
    }
    

    
    func goBackToHomepage()
    {
        performSegue(withIdentifier: "goBackToHomePage", sender: self)
    }
    
    func NASAApiPicture () {
        
        self.view.addSubview(self.imageNASAView)
        self.imageNASAView.translatesAutoresizingMaskIntoConstraints = false
        self.imageNASAView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.imageNASAView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.imageNASAView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        self.imageNASAView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true

        
        NASA_API_Client.getMediaType { (mediaType) in
            
            if mediaType == "video"
            {
                OperationQueue.main.addOperation({ 
                    self.imageNASAView.image = UIImage.init(named: "spaceImage4.jpg")
                })
                
            }
            else
            {
                NASA_API_Client.getPhotoOfDay { (spaceImage) in
                    OperationQueue.main.addOperation({
                        self.imageNASAView.image = spaceImage
                    })
                }
            }
            
        }
        

        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.iconsArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        
        print("cell \((indexPath as NSIndexPath).row) is getting created")
        
        cell.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        
        let zodiacName = UILabel()
        let signIconView = UIImageView()
        
        signIconView.contentMode = .scaleAspectFit
        signIconView.clipsToBounds = true
        signIconView.tintColor = UIColor.white
        
        
        zodiacName.textAlignment = NSTextAlignment.center
        zodiacName.textColor = UIColor.white
        zodiacName.font = UIFont(name: "BradleyHandITCTT-Bold", size: 16.0)
        zodiacName.adjustsFontSizeToFitWidth = true
        
        
        cell.addSubview(signIconView)
        cell.addSubview(zodiacName)
        
        signIconView.translatesAutoresizingMaskIntoConstraints = false
        signIconView.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
        signIconView.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 0.75).isActive = true
        signIconView.topAnchor.constraint(equalTo: cell.topAnchor).isActive = true
        signIconView.leadingAnchor.constraint(equalTo: cell.leadingAnchor).isActive = true
        
        zodiacName.translatesAutoresizingMaskIntoConstraints = false
        zodiacName.centerXAnchor.constraint(equalTo: signIconView.centerXAnchor).isActive = true
        zodiacName.topAnchor.constraint(equalTo: signIconView.bottomAnchor).isActive = true
        zodiacName.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
        
        
        
        let icon = iconsArray[(indexPath as NSIndexPath).row]
        signIconView.image = UIImage(named: icon)
        
        zodiacName.text = iconsDictionary[icon]?.capitalized
        
        cell.isUserInteractionEnabled = true
        
        signIconView.isUserInteractionEnabled = false
        zodiacName.isUserInteractionEnabled = false
        
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: imageNASAView.frame.width/5.5, height: imageNASAView.frame.height/6.5)
        // return CGSizeMake(, collectionView.frame.height/4)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //self.performSegueWithIdentifier("dailyHoroscope", sender: iconsArray[indexPath.item])
        
        let iconArrayString = iconsArray[(indexPath as NSIndexPath).row]
        
        if let unwrappedString = iconsDictionary[iconArrayString]
        {
            self.collectionViewHoroscopeString = unwrappedString
        }
        
        
        print(self.collectionViewHoroscopeString)
        self.performSegue(withIdentifier: "dailyHoroscope", sender: self.collectionViewHoroscopeString)
        
        
        
        
    }
    
    //    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
    //
    //        let cell = UICollectionViewCell()
    //
    //        if cell.highlighted == true {
    //            cell.layer.borderColor = UIColor.purpleColor().CGColor
    //        } else {
    //
    //            cell.layer.borderColor = UIColor.clearColor().CGColor
    //        }
    //
    //    }
    //
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        print("prepare for segue")
        //
        //       print("\(sender) we're in the prepare for segue")
        //
        //
        //
        //        if segue.identifier == "dailyHoroscope" {
        //
        //            let destinationHoroscopeVC: HoroscopeViewController = segue.destinationViewController as! HoroscopeViewController
        //            let selectedCell = sender as! UICollectionViewCell
        //            let indexPath = self.collectionView.indexPathForCell(selectedCell)
        //            let zodiacImage = iconsArray[indexPath!.row]
        //
        //            let iconNameString = iconsDictionary[zodiacImage]
        //            destinationHoroscopeVC.passedHoroscopeString = iconNameString
        
        
        //print("segue is  == dailyHoro")
        
        //        }
        
       
        if segue.identifier == "dailyHoroscope"
        {
            let destinationVC = segue.destination as? HoroscopeViewController
            
            destinationVC?.passedHoroscopeString = self.collectionViewHoroscopeString
        }
        
    }
    
    
    
}
