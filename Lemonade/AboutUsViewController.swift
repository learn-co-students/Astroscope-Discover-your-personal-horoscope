//
//  AboutUsViewController.swift
//  Lemonade
//
//  Created by Flatiron School on 10/11/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var informationTextView: UITextView!
    @IBOutlet weak var goBackButton: UIButton!
    override func viewDidLoad()
    {
        
        super.viewDidLoad()

        self.informationTextView.text = "Astroscope: A fun and accurate way of getting your updated daily horoscope based on your birthday sign as well as getting NASA's image of the day. \n\nAstroscope was developed at Flatiron's School in the summer of 2016. \n\n\nIcon Design: Park Ji Sun\n\nConstellation Info: http://www.astrology-online.com/"
     
        self.goBackButton.layer.borderWidth = 1
        self.goBackButton.layer.borderColor = UIColor.white.cgColor
        self.goBackButton.layer.cornerRadius = 10
        self.goBackButton.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    }

    @IBAction func goBackButton(_ sender: AnyObject)
    {
        self.performSegue(withIdentifier: "goBack", sender: self)
    }
    

}
