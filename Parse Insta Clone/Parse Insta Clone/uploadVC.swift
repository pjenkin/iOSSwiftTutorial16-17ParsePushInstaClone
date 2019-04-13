//
//  SecondViewController.swift
//  Parse Insta Clone
//
//  Created by Peter Jenkin on 11/04/2019.
//  Copyright © 2019 Peter Jenkin. All rights reserved.
//

import UIKit

class uploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postImage: UIImageView!  // NB not imageView - that's in feed
    @IBOutlet weak var commentText: UITextView!
    
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
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func uploadBtnClicked(_ sender: Any) {
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
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func hideKeyboard()        // NB @objc to avoid error Argument of '#selector' refers to instance method 'hideKeyboard()' that is not exposed to Objective-C
    {
        //self.view.endEditing(<#T##force: Bool##Bool#>)
        self.view.endEditing(true)      // force keyboard (ie editing) to end (ie to hide)
    }
    
}

