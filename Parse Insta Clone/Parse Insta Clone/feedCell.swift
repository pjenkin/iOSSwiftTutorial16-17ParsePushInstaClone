//
//  feedCell.swift
//  Parse Insta Clone
//
//  Created by Peter Jenkin on 13/04/2019.
//  Copyright © 2019 Peter Jenkin. All rights reserved.
//

import UIKit

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
    }
    @IBAction func commentBtnClicked(_ sender: Any) {
    }
}
