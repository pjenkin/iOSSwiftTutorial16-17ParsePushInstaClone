//
//  FirstViewController.swift
//  Parse Insta Clone
//
//  Created by Peter Jenkin on 11/04/2019.
//  Copyright © 2019 Peter Jenkin. All rights reserved.
//

import UIKit
import Parse

class feedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    var postImageArray = [PFFileObject]()
    var commentTextArray = [String]()
    var postOwnerArray = [String]()
    var postUuidArray = [String]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set up table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // get feed data from server
        getDataFromServer()
    }
    
    // when, and only when new upload performed, with redirect, in view do the getDataFromServer to show feed - updated - with new post in among feed
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(feedVC.getDataFromServer), name: NSNotification.Name(rawValue: "newUpload"), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // minimum 2 delegate functions for tableView
    // ... numberofrowsin  .. cellforrow....
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return 10       // tempor ary check for now
        return postImageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = UITableViewCell()
        // populate Prototype cell(s) with bespoke cell object
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! feedCell
        // cell.textLabel?.text = "Checking table setup"        // diagnostic
        //cell.usernameLabel.text = "checking username label"   // diagnostic
        
        cell.postuuidLabel.isHidden = true
        cell.usernameLabel.text = postOwnerArray[indexPath.row]
        cell.postComment.text = commentTextArray[indexPath.row]
        cell.postuuidLabel.text = postUuidArray[indexPath.row]
        
        postImageArray[indexPath.row].getDataInBackground {(data,error) in
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
                cell.postImage.image = UIImage(data: data!)
            }
        }
        
        
        

        return cell
    }
    
    
    // using additional delegate function, set height of prototype cell programmatically  https://stackoverflow.com/a/46438939
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
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

    // NB @objc to avoid (at #selector) error: Argument of '#selector' refers to instance method 'getDataFromServer()' that is not exposed to Objective-C
    /// function to get feed data from server (Parse server db in this case)
    @objc func getDataFromServer()
    {
        let query = PFQuery(className: "Posts")
        query.addDescendingOrder("createdAt")           // sort by date, oldest-first
        query.findObjectsInBackground {(posts, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                self.present(alert, animated: true, completion: nil)
                // NB 1st: the Alert Controller, then 2nd: the button (as an AlertAction), then 3rd: add button action to the controller, 4th: present the alert to the user
                print(error?.localizedDescription)
            }
        else
            {
                print(posts)      // diagnostic
                
                self.postImageArray.removeAll(keepingCapacity: false)
                self.commentTextArray.removeAll(keepingCapacity: false)
                self.postOwnerArray.removeAll(keepingCapacity: false)
                self.postUuidArray.removeAll(keepingCapacity: false)
                
                for post in posts!
                {
                    // TODO will throw errors if blank fields in db
                    self.postImageArray.append(post.object(forKey: "postImage") as! PFFileObject)
                    self.commentTextArray.append(post.object(forKey: "commentText") as! String)
                    self.postOwnerArray.append(post.object(forKey: "postOwner") as! String)
                    self.postUuidArray.append(post.object(forKey: "postUuid") as! String)
                }
            }
            self.tableView.reloadData()
        }
    }
}

