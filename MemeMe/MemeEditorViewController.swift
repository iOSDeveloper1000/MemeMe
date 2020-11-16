//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Arno Seidel on 03.11.20.
//

import UIKit
import AVFoundation


// MARK: Static elements

let defaultTextTop: String = "Enter top text here"
let defaultTextBottom: String = "Enter bottom text here"


// MARK: Class MemeEditorViewController

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    // MARK: Properties
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -6.0
    ]
    
    var memedImage: UIImage!
    
    // Set by instantiating view controller such that table / collection can be reloaded
    var completionHandle: () -> Void = {}
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTextFieldProperties(topTextField, defaultText: defaultTextTop)
        self.setTextFieldProperties(bottomTextField, defaultText: defaultTextBottom)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.shareButton.isEnabled = false
        
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Adapt the text fields in case the device is rotated
        coordinator.animate(alongsideTransition: nil) { _ in
            if let image = self.imageView.image {
                self.alignTextFieldInImage(image)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.unsubscribeFromKeyboardNotifications()
    }

    
    // MARK: Actions
    
    @IBAction func pickanImageFromAlbum(_ sender: Any) {
        self.pickAnImage(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageByCamera(_ sender: Any) {
        self.pickAnImage(sourceType: .camera)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        
        self.memedImage = self.generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [self.memedImage!], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if !completed {
                return
            }
            
            self.save()
            self.completionHandle()
        }
        
        self.present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancelEditor(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageView.image = image
            self.alignTextFieldInImage(image)
            
            // Enable Share button
            self.shareButton.isEnabled = true
        } else {
            print("image is nil")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: UITextFieldDelegate methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField.text = ""
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    // MARK: Helper methods
    
    func pickAnImage(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func setTextFieldProperties(_ textfield: UITextField, defaultText: String = "") {
        textfield.text = defaultText
        textfield.defaultTextAttributes = memeTextAttributes
        textfield.textAlignment = .center
        textfield.delegate = self
    }
    
    func alignTextFieldInImage(_ myImage: UIImage) {
        
        // Get the outline of the current image rectangular
        let imageRectangular = AVMakeRect(aspectRatio: myImage.size, insideRect: self.imageView.bounds)
        
        // Adapt top and bottom textfield for the size of the chosen image
        for constraint in self.view.constraints {
            if constraint.identifier == "horizontalTextFieldConstraint" {
                constraint.constant = 10.0 + 0.5 * (self.imageView.frame.size.width - imageRectangular.width)
            } else if constraint.identifier == "verticalTextFieldConstraint" {
                constraint.constant = 15.0 + 0.5 * (self.imageView.frame.size.height - imageRectangular.height)
            }
        }
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navigationbar in meme
        self.hideToolbarAndNavBar(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Present toolbar and navigationbar again
        self.hideToolbarAndNavBar(false)
        
        return memedImage
    }
    
    // Create a meme object and save it to the memes array in the app delegate
    func save() {
        
        // Update the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: self.imageView.image!, memedImage: self.memedImage!)
        
        // Add it to the memes array in app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func hideToolbarAndNavBar(_ hidden: Bool) {
        self.navigationBar.isHidden = hidden
        self.toolBar.isHidden = hidden
    }
    
    
    // MARK: Keyboard Notification methods
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        // Change view only for the bottom text field
        if self.bottomTextField.isEditing {
            self.view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        // Set frame back in case of keyboard is hiding
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
}
