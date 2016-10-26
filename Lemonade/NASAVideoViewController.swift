//
//  NASAVideoViewController.swift
//  Lemonade
//
//  Created by Susan Zheng on 10/10/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class NASAVideoViewController: UIViewController
{

    @IBOutlet weak var videoWebView: UIWebView!
    
    var request : URLRequest!
    var webViewDimmed : Bool = false
    var backgroundTapped : UIGestureRecognizer!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        NASA_API_Client.getNASAPhotoInfo { (videoURL) in
            let urlString = videoURL["url"] as! String
            let title = videoURL["title"] as! String
            let url = URL(string: urlString)
            if let unwrappedURL = url{
                self.request = URLRequest(url: unwrappedURL)
            }
            
            OperationQueue.main.addOperation({ 
                self.videoWebView.loadRequest(self.request)
                self.title = title
            })
            
        }
        
        self.navigationItem.leftBarButtonItem =
            UIBarButtonItem(image: UIImage.init(named: "customBackButton.png"), style: .done, target: self, action: #selector (NASAVideoViewController.backButtonPressed))
    }
    
    func backButtonPressed(sender:UIButton)
    {
        navigationController?.popViewController(animated: true)
    }


}
