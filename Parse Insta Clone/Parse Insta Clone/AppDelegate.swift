//
//  AppDelegate.swift
//  Parse Insta Clone
//
//  Created by Peter Jenkin on 11/04/2019.
//  Copyright © 2019 Peter Jenkin. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let config = ParseClientConfiguration {
            (ParseMutableClientConfiguration) in
            ParseMutableClientConfiguration.applicationId = "4db3417ac4d79c34640760d3c13c3728cd26604a"
            ParseMutableClientConfiguration.clientKey = "571c1e762705f9975f4aafd4f91cb373d6e23d9f"
            ParseMutableClientConfiguration.server = "http://34.251.9.205:80/parse"
            // NB 3 vital values for Parse server connection (applicationId, clientKeyserver)
            // used from AWS or other host/server
            // all using ParseMutableClientConfiguration
            // Parse server values obtained from apps/parse/htdocs/server.js (via SSH log-in to AWS EC2 instance)
            // applicationId == appId; clientKey == masterKey; server == serverURL
        }
        Parse.initialize(with: config)
        let defaultACL = PFACL()    // Parse File? Access Control List ??
        defaultACL.hasPublicReadAccess = true           // getPublicReadAccess = true??
        defaultACL.hasPublicWriteAccess = true          // getPublicWriteAccess = true??
        PFACL.setDefault(defaultACL, withAccessForCurrentUser: true)
        
        rememberLogin()         // if user has already logged-in, bypass log-in view
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    /// bespoke function for remembering logged-in-ness
    /// called from func application(...)
    func rememberLogin()
    {
        let user : String? = UserDefaults.standard.string(forKey: "userLoggedIn")
        
        if user != nil
        {
            
            let board : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBar = board.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController       // // NB withIdentifier: Identity Inspector/ Storyboard ID
            
            // now set to go straight to tabBar ie feed/upload
            window?.rootViewController = tabBar
        }
    }    
}

