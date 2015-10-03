//
//  ViewController.swift
//  MemeMe
//
//  Created by Daniel Butts on 8/28/15.
//  Copyright (c) 2015 Daniel Butts. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    //TODO: Connect Cancel button (what deos this do?)
    
    var sentMemes = [Meme]()
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        shareButton.enabled = false
        
        topText.delegate = self;
        bottomText.delegate = self;
        setTextAttributes(topText, fieldText: "TOP")
        setTextAttributes(bottomText, fieldText: "BOTTOM")
        
        
    }

    func setTextAttributes(field: UITextField, fieldText: String) {
        field.text = fieldText
        field.textAlignment = NSTextAlignment.Center
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
            NSStrokeWidthAttributeName : -3
        ]

        field.defaultTextAttributes = memeTextAttributes
        field.backgroundColor = UIColor.clearColor()
        field.borderStyle = UITextBorderStyle.None
        field.textAlignment = .Center
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // Image Picking Functions
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        pickAnImage(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        pickAnImage(UIImagePickerControllerSourceType.Camera)
    }
    
    func pickAnImage(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .ScaleAspectFit
            imagePickerView.image = image
            shareButton.enabled = true
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage
    {
        //TODO: only grab extents of scaled image
        
        // Hide toolbar and navbar
        topBar.hidden = true
        bottomBar.hidden = true
        
        
        
        UIGraphicsBeginImageContext(imagePickerView.frame.size)
        view.drawViewHierarchyInRect(imagePickerView.frame, afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Restore toolbar and navbar
        topBar.hidden = false
        bottomBar.hidden = false
        
        return memedImage
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        let controller = UIActivityViewController(activityItems: [generateMemedImage()], applicationActivities: nil)
        
        controller.completionWithItemsHandler = {
            (activityType: String!, completed Bool, items: [AnyObject]!, err:NSError!) -> Void in
            
            self.save()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func save() {
        //TODO: Save Meme object to persistent storage on phone
        
        var meme = Meme( topText: topText.text!, bottomText: bottomText.text!, image: imagePickerView.image!, memedImage: generateMemedImage())
        sentMemes.append(meme)
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    


    // Meme Text Editing Functions
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() == true {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomText.isFirstResponder() == true {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    // TextFieldDelegate Functions
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var oldText = textField.text as NSString
        var newText = oldText.stringByReplacingCharactersInRange(range, withString: string.uppercaseString)
        textField.text = String(newText)
        
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if textField.text == "" {
            if bottomText.isFirstResponder() == true {
                textField.text = "BOTTOM"
            } else {
                textField.text = "TOP"
            }
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
}

