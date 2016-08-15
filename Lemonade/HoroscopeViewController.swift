//
//  ViewController.swift
//  Lemonade
//
//  Created by Flatiron School on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class HoroscopeViewController: UIViewController
{
    var passedHoroscopeString : String = ""
    
    @IBOutlet weak var horoscopeLabel: UILabel!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        horoscopeLabel.text = passedHoroscopeString
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

