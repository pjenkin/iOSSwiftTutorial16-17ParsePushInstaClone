//
//  feedCell.swift
//  Parse Insta Clone
//
//  Created by Peter Jenkin on 13/04/2019.
//  Copyright © 2019 Peter Jenkin. All rights reserved.
//

import UIKit
import Parse

class feedCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var postComment: UITextView!
    
    @IBOutlet weak var postuuidLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeBtnClicked(_ sender: Any) {
        let likeObject = PFObject(className: "Likes")
        likeObject["from"] = PFUser.current()!.username!        // person using at mo is one liking
        likeObject["to"] = postuuidLabel.text
        
        likeObject.saveInBackground {(success, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                // self.present(alert, animated: true, completion: nil)
                // NB 1st: the Alert Controller, then 2nd: the button (as an AlertAction), then 3rd: add button action to the controller, 4th: present the alert to the user
                // NB in this case as using TableViewCell, cannot present Alert so use underlying ViewController instead
                print(error?.localizedDescription)
            }
            else
            {
                print("Like has been saved to server")
            }
        }
    }
    @IBAction func commentBtnClicked(_ sender: Any) {
        // NB TODO text of comment not actually included here - needs another control?
        let commentObject = PFObject(className: "Comments")
        commentObject["from"] = PFUser.current()!.username!        // person using at mo is one commenting
        commentObject["to"] = postuuidLabel.text
        
        commentObject.saveInBackground {(success, error) in
            if error != nil
            {
                let alert = UIAlertController(title: "Error", message:error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let button = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(button)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                // self.present(alert, animated: true, completion: nil)
                // NB 1st: the Alert Controller, then 2nd: the button (as an AlertAction), then 3rd: add button action to the controller, 4th: present the alert to the user
                // NB in this case as using TableViewCell, cannot present Alert so use underlying ViewController instead
                print(error?.localizedDescription)
            }
            else
            {
                print("Comment has been saved to server")
            }
        }
    }
}
