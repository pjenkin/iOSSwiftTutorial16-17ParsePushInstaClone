//
//  signUpVC.swift
//  Parse Insta Clone
//
//  Created by Peter Jenkin on 11/04/2019.
//  Copyright © 2019 Peter Jenkin. All rights reserved.
//

import UIKit
import Parse

class signUpVC: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

/*
         // temporary code to check Parse connection working ok - should see result in Parse web console
         let checkObject = PFObject(className: "Animals")        // add a class
         // class names visible in Parse dashboard (eg http://34.247.48.250/apps/) a la tables
         checkObject["name"] = "Fungal Ferret"
         checkObject["colour"] = "Brown"
         checkObject["age"] = 5
         checkObject.saveInBackground()      // avoid having to write do ... try block
         {(success, error) in
         if error != nil
         {
         print(error?.localizedDescription)
         }
         else
         {
         print(success)
         }
         }
         
 */
/*
        // temporary code to check Parse connection working ok - should see result in Parse web console
        let checkObject = PFObject(className: "Animals")        // add a class
        // class names visible in Parse dashboard (eg http://34.247.48.250/apps/) a la tables
        checkObject["name"] = "Angry Bear"
        checkObject["colour"] = "Red"
        checkObject["age"] = 5
        checkObject.saveInBackground()      // avoid having to write do ... try block
            {(success, error) in
                if error != nil
                {
                    print(error?.localizedDescription)
                }
                else
                {
                    print(success)
                }
            }
 */
/*
        // temporary check by querying
        
        let query = PFQuery(className: "Animals")
        //query.whereKey(<#T##key: String##String#>, equalTo: <#T##Any#>)
        query.whereKey("name", equalTo: "Fungal Ferret")
        query.findObjectsInBackground
            {
                (objects, error) in
                if error != nil
                {
                    print(error?.localizedDescription)
                }
                else
                {
                    print(objects)      // check the debug output console
                }
        }
*/
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInBtnClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != ""
        {
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) {(user, error) in
                if error != nil
                {
                    print(error?.localizedDescription)
                }
                else
                {
                    print("\(user?.username)")
                }
            }
        }
        
    }
    
    @IBAction func signUpBtnClicked(_ sender: Any) {
        let user = PFUser()         // set up a Parse user
        user.username = usernameText.text
        user.password = passwordText.text
        // user["age"]  // example possible usage with Parse (for non-username or non-password)
        user.signUpInBackground {
            (success, error) in
        if error != nil
        {
            print(error?.localizedDescription)
        }
        else
        {
            print("User has been added")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    }
}
