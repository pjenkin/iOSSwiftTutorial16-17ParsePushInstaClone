//
//  FirstViewController.swift
//  Parse Insta Clone
//
//  Created by Peter Jenkin on 11/04/2019.
//  Copyright © 2019 Peter Jenkin. All rights reserved.
//

import UIKit
import Parse

class feedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logoutBtnClicked(_ sender: Any) {
        PFUser.logOutInBackground {(error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                // set up button ready for user acknowledgement on alert
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                // show alert with button
                self.present(alert, animated: true, completion: nil)

            }
            else
            {
                UserDefaults.standard.removeObject(forKey: "userLoggedIn")  // remember that no user i is now logged-in
                
                UserDefaults.standard.synchronize()     // update the UserDefaults db
                
                let signUp = self.storyboard?.instantiateViewController(withIdentifier: "signUpVC") as! signUpVC
                
                // refer to AppDelegate.swift code
                let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                delegate.window?.rootViewController = signUp
                
                delegate.rememberLogin()
                
            }
        }
    }
    
}

