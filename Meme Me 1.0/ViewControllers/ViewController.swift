//
//  ViewController.swift
//  Meme Me 1.0
//
//  Created by Sushma Adiga on 03/05/21.
//
import Foundation
import UIKit



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    var memeImage: UIImage!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topViewTextField: UITextField!
    @IBOutlet weak var bottomViewTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
        tabBarController?.tabBar.isHidden = true
    }
    
    
    @IBAction func ImagePickerView(_ sender: Any) {
        pickAnImage(sourceType: .photoLibrary)
    }
    
    
    @IBAction func Camera(_ sender: Any) {
        if !isCameraAvailable() {
            return
        }
        pickAnImage(sourceType: .camera)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        
        shareButton.isEnabled = false
        imagePickerView.image = nil
        topViewTextField.text = nil
        bottomViewTextField.text = nil
        dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func share(_ sender: Any) {
        let memedImage = generateImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, error -> () in
            if (completed) {
                self.save()
                activityViewController.dismiss(animated: true, completion: nil)
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        guard let image = info[.originalImage] as? UIImage else {return}
        imagePickerView.image = image
        shareButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func pickAnImage(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func setTextField(_ textField: UITextField) {
        let memeTextAttributes : [NSAttributedString.Key : Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .strikethroughColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBold", size: 40)!,
            .strokeWidth: -3.0
        ]
        textField.defaultTextAttributes = memeTextAttributes
        textField.adjustsFontSizeToFitWidth = true
        textField.textAlignment = .center
        textField.allowsEditingTextAttributes = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func generateImage() -> UIImage {
        
        hideTopAndBottomBars(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideTopAndBottomBars(false)
        
        return memedImage
    }
    
    
    func hideTopAndBottomBars(_ hide: Bool) {
        navigationBar.isHidden = hide
        bottomToolbar.isHidden = hide
    }
    
    
    
    
    func prepareView() {
        self.topViewTextField.delegate = self
        self.bottomViewTextField.delegate = self
        self.setTextField(self.topViewTextField)
        self.setTextField(self.bottomViewTextField)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if bottomViewTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save() {
        
        let generateImage =  Meme(topText: topViewTextField.text!, bottomText: bottomViewTextField.text!, originalImage: imagePickerView.image!, memedImage: generateImage())
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(generateImage)
        dismiss(animated: true, completion: nil)
    }
    
    
    func setViewControlsToInitialState() {
        imagePickerView.image = nil
        shareButton.isEnabled = false
        topViewTextField.text = Constants.TopStartText
        bottomViewTextField.text = Constants.BottomStartText
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, error -> () in
            if (completed) {
                self.save()
                activityViewController.dismiss(animated: true, completion: nil)
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
    
}








