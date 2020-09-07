//
//  SignUpViewController.swift
//  Project
//
//  Created by Dishant Patel on 2020-05-26.
//  Copyright © 2020 Dishant Patel. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import AVFoundation

class SignUpViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    //MARK-OUTLETS
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var phoneNumberTextfield: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    
    //MARK-VARIABLES
    var imagePicker:UIImagePickerController!
    var image:UIImage?
    var users:[User]?
    
    //MAIN FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        phoneNumberTextfield.delegate = self
    }

    //MARK-ACTIONS
    //Action when select button is pressed
    @IBAction func selectImageButtonPressed(_ sender: Any) {
        let alertBox = UIAlertController(
            title: "Select Image",
            message: "Select source from where you want to choose the image",
            preferredStyle: .actionSheet
        )
        alertBox.addAction(
            UIAlertAction(title:"Choose from Photos", style: .default, handler:{
                action in
                self.imagePicker = UIImagePickerController()
                if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false) {
                    let box = UIAlertController(
                        title: "Photos unavailable",
                        message: "Sorry we don't have rights to access your gallery!!",
                        preferredStyle: .alert
                    )
                    box.addAction(
                        UIAlertAction(title:"OK", style: .default, handler:nil)
                    )
                    self.present(box, animated:true)
                }
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated:true)
            })
        )
        alertBox.addAction(
            UIAlertAction(title:"Take a Photo", style: .default, handler:{
                action in
                self.imagePicker = UIImagePickerController()
                if (UIImagePickerController.isSourceTypeAvailable(.camera) == false) {
                    self.imagePicker.sourceType = .savedPhotosAlbum
                }
                else {
                    self.imagePicker.sourceType = .camera
                }
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated:true)
            })
        )
        self.present(alertBox, animated:true)
    }
    
    //Action when user clicks on Sign Up Button
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let email = emailTextfield.text!
        let password = passwordTextfield.text!
        let phoneNumber = Int64(phoneNumberTextfield.text!)
        if email.isEmpty || password.isEmpty || phoneNumberTextfield.text!.count != 10 {
            let box = UIAlertController(
                title: "Incomplete Details",
                message: "Please fill all details to register",
                preferredStyle: .alert
            )
            box.addAction(
                UIAlertAction(title:"OK", style: .default, handler:nil)
            )
            self.present(box, animated:true)
        }
        else {
            addUser(email:email, password:password, phoneNumber:phoneNumber!)
        }
    }
    
    //Function to control images selected view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard (info[UIImagePickerController.InfoKey.mediaType] as? String) != nil else {
                return
        }
        picker.dismiss(animated: true)
        let photoTakenFromCamera = info[.originalImage] as? UIImage
        image = photoTakenFromCamera!
        self.profileImageView.image = photoTakenFromCamera
    }
    
    //Function called to minimize keyboard when clicked on return from keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Function saves image to local directory
    func saveImage(image:UIImage, name:String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name + ".png")
        print(paths)
        let imageData = image.pngData()
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    //Function searched for data from database
    func searchUser(email:String) -> [User] {
        var users:[User] = [User]()
        let request : NSFetchRequest<User> = User.fetchRequest()
        let query = NSPredicate(format: "email == %@", email)
        request.predicate = query
        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let results = try db.fetch(request)
            users = results
        }
        catch {
            print("Error searching for the data!!")
        }
        return users
    }
        
    //Function saves new user to database
    func addUser(email:String, password:String, phoneNumber:Int64) {
        users = searchUser(email: email)
        if users?.count == 0 {
            let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let user = User(context: db)
            user.email = email
            user.password = password
            user.phoneNumber = phoneNumber
            user.imageName = user.email
            do {
                try db.save()
                saveImage(image: image!, name: user.imageName)
                let box = UIAlertController(
                    title: "Save Successful",
                    message: "User has been created successfully. Now you can try to login with same credentials.",
                    preferredStyle: .alert
                )
                box.addAction(
                    UIAlertAction(title:"OK", style: .default, handler:nil)
                )
                self.present(box, animated:true)
                emailTextfield.text = ""
                passwordTextfield.text = ""
                phoneNumberTextfield.text = ""
                profileImageView.image = nil
            } catch  {
                print("Save Unsuccessful!!")
            }
        }
        else {
            let box = UIAlertController(
                title: "Email already exists",
                message: "Sorry!! This email already exists in the system. Please try to enter a different one.",
                preferredStyle: .alert
            )
            box.addAction(
                UIAlertAction(title:"OK", style: .default, handler:nil)
            )
            self.present(box, animated:true)
        }
    }
}
