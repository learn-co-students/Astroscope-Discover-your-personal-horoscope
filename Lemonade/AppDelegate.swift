//
//  AppDelegate.swift
//  Lemonade
//
//  Created by Susan Zheng on 8/12/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?



    var store = DataStore.sharedDataStore

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        
        
        let userRequest = NSFetchRequest<Users>(entityName: Users.entityName)
        
        do{
            let object = try store.managedObjectContext.fetch(userRequest)
            
            if object.count == 0
            {
                let storyBoard = UIStoryboard(name: "WelcomePage", bundle: nil)
                
                let initialViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomePage") as? WelcomePageViewController
                
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
                
                return true
            }
            else if object.count > 0
            {
                
                let storyboard = UIStoryboard(name: "DatePicker", bundle: nil)
                
                let nextViewController = storyboard.instantiateViewController(withIdentifier: "navController") as? UINavigationController
                
                self.window?.rootViewController = nextViewController
                self.window?.makeKeyAndVisible()
                
                return true
            }
            
        }catch{
            print("error")
        }
       
        return true
    
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.reachabilityChanged, object: nil)
        store.saveContext()
    }



    
}

