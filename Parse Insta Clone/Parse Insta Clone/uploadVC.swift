//
//  SecondViewController.swift
//  Parse Insta Clone
//
//  Created by Peter Jenkin on 11/04/2019.
//  Copyright © 2019 Peter Jenkin. All rights reserved.
//

import UIKit
import Parse

class uploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postImage: UIImageView!  // NB not imageView - that's in feed
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var uploadBtn: UIButton!     // NB declared as outlet as well as action, to enable button to be deactivated until image ready to upload
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // for hiding any on-screen keyboard
        let hideKeyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadVC.hideKeyboard))
        self.view.addGestureRecognizer(hideKeyboardGestureRecognizer)
        // NB assigned to entire view - tap anywhere on exposed view (ie not on keyboard, or text edit control &c) to hide keyboard
        
        // for choosing an image
        postImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadVC.selectImage))
        postImage.addGestureRecognizer(gestureRecognizer)
        
        // disable button until image ready to upload
        uploadBtn.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func uploadBtnClicked(_ sender: Any) {
        
        // now upload under way, disable button to prevent impatient click-click double-uploading
        uploadBtn.isEnabled = false
        
        let postObject = PFObject(className: "Posts")        // add a class
        // class names visible in Parse dashboard (eg http://34.247.48.250/apps/) a la tables
        postObject["commentText"] = self.commentText.text
        postObject["postOwner"] = PFUser.current()!.username!
        // UIImageJPEGRepresentation(<#T##image: UIImage##UIImage#>, <#T##compressionQuality: CGFloat##CGFloat#>)
        if let image = UIImageJPEGRepresentation(self.postImage.image!, 0.5)
        {
            var parseImageFile = PFFileObject(name: "image.jpg", data: image)
            postObject["postImage"] = parseImageFile
        }
        else
        {
            print("Error processing image file data")
        }
        
        let uuid = UUID().uuidString
        postObject["postUuid"] = "\(uuid) \(PFUser.current()!.username!)"
        postObject.saveInBackground()      // avoid having to write do ... try block
            {(success, error) in
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
                    // assuming successful upload, reset controls of upload view
                    self.postImage.image = UIImage(named: "select-picture.png")
                    self.commentText.text = ""
                    self.tabBarController?.selectedIndex = 0    // 0: viz the initial tab view controller, to the first ViewController ie feedVC - redirect thither
                    
                    // go back and show the uploaded post, by usin Notification Center with notification Id's by string, say, "newUpload" - cf observe in viewWillLoad in feedVC
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newUpload"), object: nil)
                }

        /*
        postObject.saveInBackground()      // avoid having to write do ... try block
            {(success, error) in
                if error != nil
                {
                    print(error?.localizedDescription)
                }
                else
                {
                    print(success)
                    // if ok so far saving non-image data, try saving image
                    
                    
                    // UIImageJPEGRepresentation(<#T##image: UIImage##UIImage#>, <#T##compressionQuality: CGFloat##CGFloat#>)
                    if let image = UIImageJPEGRepresentation(self.postImage.image!, 0.5)
                    {
                        var parseImageFile = PFFileObject(name: "image.jpg", data: image)
                        postObject["postImage"] = parseImageFile
                        
                        
                        parseImageFile?.saveInBackground(
                            { (success, error) -> Void in               // https://stackoverflow.com/a/39600740
                                if error == nil
                                {
                                    print("uploaded image")
                                    // assuming successful upload, reset controls of upload view
                                    self.postImage.image = UIImage(named: "select-picture.png")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0    // 0: viz the initial tab view controller, to the first ViewController ie feedVC - redirect thither
                                }
                                else
                                {
                                    print(error?.localizedDescription)
                                    // TODO would be nice to rollback data here, as in a transaction
                                }
                            })
                        
                    }
                    else
                    {
                        print("Problem processing image file data")
                    }
                }*/
        }
    }
    
    /// select an image to upload - handler for image Tap gesturerecognized
    @objc func selectImage()
    {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self        // thus self (ViewController) mus subclass UIImagePickerControllerDelegate, UINavigationControllerDelegate
        pickerController.sourceType = .photoLibrary // could use camera alternatively
        pickerController.allowsEditing = true       // NB editing will require check in code (cf didFinishPickingMediaWithInfo)
        present(pickerController, animated: true, completion: nil)
    }

    // pre-built handler for picker, ready to fill with code
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // postImage.image = info
        // NB will require 'Privacy - Photo Library Usage Description' in PList.info
        
        
        var selectedImageFromPicker: UIImage?   // workaround to get original image https://stackoverflow.com/a/53219069
        
        // postImage.image = info[UIImagePickerControllerEditedImage] as? UIImage // didn't work as original image slipped through unused - no edited image to use
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage
        {   // NB Any type from dictionary - try to cast to UIImage
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            selectedImageFromPicker = originalImage
        }
        
        // cautious approach here!
        if let selectedImage = selectedImageFromPicker
        {
            postImage.image = selectedImage
            
            // now enable upload button, since an image is available
            uploadBtn.isEnabled = true
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideKeyboard()        // NB @objc to avoid error Argument of '#selector' refers to instance method 'hideKeyboard()' that is not exposed to Objective-C
    {
        //self.view.endEditing(<#T##force: Bool##Bool#>)
        self.view.endEditing(true)      // force keyboard (ie editing) to end (ie to hide)
    }
    
}

