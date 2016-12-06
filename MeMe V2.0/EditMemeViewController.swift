//
//  EditMemeViewController.swift
//  MeMe V2.0
//
//  Created by Rakesh Kumar on 27/11/16.
//  Copyright © 2016 Rakesh Kumar. All rights reserved.
//

import UIKit

class EditMemeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    // Meme image and text
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    
    // Top Bar
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    // Bottom Bar
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var selectedTextField: UITextField!
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.isEnabled = false
        saveButton.isEnabled = false
        let textFieldsArray = [topTextField,bottomTextField]
        textFieldsConfiguration(textFields: textFieldsArray)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyBoardNotificatin()
        cameraAvailabilityCheck()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyBoardNotification()
    }

    

    // MARK: -TextFields Configuration
    func textFieldsConfiguration(textFields: [UITextField?])
    {
        let memeTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSStrokeColorAttributeName: UIColor.black,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 40)!,
            NSStrokeWidthAttributeName : -4.0
        ] as [String : Any]
        
        for textField in textFields
        {
            textField?.defaultTextAttributes = memeTextAttributes
            textField?.textAlignment = .center
            textField?.delegate = self
        }
    }

    // MARK: - KeyBoard Resigning and Notification
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
    }
    
    func keyBoardWillShow(_ notification:Notification){
        
        if bottomTextField.isFirstResponder && view.frame.origin.y == 0{
            view.frame.origin.y = getKeyBoardHeight(notification) * -1
        }
    }
    
    func getKeyBoardHeight(_ notification:Notification) -> CGFloat{
        
        let userInfo = notification.userInfo
        let keyBoardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyBoardSize.cgRectValue.height
    }
    
    func keyBoardWillHide(_ notification:Notification){
        if bottomTextField.isFirstResponder{
             view.frame.origin.y = 0
        }
    }
    
    func subscribeToKeyBoardNotificatin(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyBoardNotification(){
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    // MARK: - Image Picking and delegation
    
    @IBAction func pickAnImage(_ sender: UIBarButtonItem){
        
        if sender.tag == 1{
            presentImagePickerType(source: .camera)
        }else{
            presentImagePickerType(source: .photoLibrary)
        }
    }
    
    func presentImagePickerType(source sourceType : UIImagePickerControllerSourceType){
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.imagePickerView.image = image
            shareButton.isEnabled = true
            saveButton.isEnabled = true
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    // Check for camera avaialbility in device
    func cameraAvailabilityCheck()
    {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    // MARK: - cancel Button Pressed
    @IBAction func cancelButtonPressed(sender: AnyObject)
    {
        topTextField.text = nil                     // Clear Top TextField
        bottomTextField.text = nil                  // Clear Bottom TextField
        imagePickerView.image = nil                     // Clear ImageViewer
        shareButton.isEnabled = false                 // Disabled share button
        if(selectedTextField != nil)
        {
            selectedTextField.resignFirstResponder()   // Keyboard should resign
        }
    }

    // MARK: - Share button pressed
    
    @IBAction func shareMeme(_ sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { activity,completed, items,error in
            if completed{
                self.save(memedImage)
                self.cancelButtonPressed(sender: true as AnyObject)
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad{
            
        
                activityViewController.popoverPresentationController?.barButtonItem = shareButton
            
        }
        present(activityViewController, animated: true, completion:nil)

    
    }
    
    @IBAction func saveButtonPressed(_ sender:AnyObject){
        
        let memedImage = generateMemedImage()
        self.save(memedImage)
        //TODO: unwind segue instead of dismiss
        dismiss(animated: true, completion: nil)
    }
    
    func save(_ memedImage:UIImage){
        let meme = MemeModel(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        MemeCollection.add(Meme: meme)
    
    }
    
    func toolBarVisible(_ visible:Bool){
        topBar.isHidden = !visible
        bottomBar.isHidden = !visible
    }
    
    func generateMemedImage() -> UIImage {
        
        // hide toolbar
        toolBarVisible(false)
        
        // Render view to image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in:view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // show toolbar
        toolBarVisible(true)
        
        return memedImage
    }
}

