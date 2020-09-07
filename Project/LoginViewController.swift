//
//  LoginViewController.swift
//  Project
//
//  Created by Dishant Patel on 2020-05-26.
//  Copyright © 2020 Dishant Patel. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class LoginViewController: UIViewController {

    //MARK-OUTLETS
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    //MARK-VARIABLES
    var users:[User] = [User]()
    var meals:[Mealkit] = [Mealkit]()
    
    //MAIN FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        let mealkits = searchMeal()
        if mealkits.count == 0 {
            guard let file = openFile() else { return }
            meals = getData(from: file)!
            saveData(meals: meals)
        }
    }

    //MARK-ACTIONS
    //Action when login button is pressed
    @IBAction func loginButtonPressed(_ sender: Any) {
        let email = emailTextfield.text!
        let password = passwordTextfield.text!
        if email.isEmpty || password.isEmpty {
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
            users = searchUser(email: email)
            if users.count == 0  {
                let box = UIAlertController(
                    title: "Invalid User",
                    message: "No user exists by this email",
                    preferredStyle: .alert
                )
                box.addAction(
                    UIAlertAction(title:"OK", style: .default, handler:nil)
                )
                self.present(box, animated:true)
            }
            else if users[0].password == password {
                let defaults = UserDefaults.standard
                defaults.set(users[0].email, forKey: "email")
            }
            else {
                let box = UIAlertController(
                    title: "Incorrect Password",
                    message: "Please check the entered password",
                    preferredStyle: .alert
                )
                box.addAction(
                    UIAlertAction(title:"OK", style: .default, handler:nil)
                )
                self.present(box, animated:true)
            }
        }
    }
     
    //Function opens the default file
    func openDefaultFile()-> String? {
        
        guard let file = Bundle.main.path(forResource:"Mealkit", ofType:"json") else {
            print("Cannot find file")
            return nil;
        }
        print("File found: \(file.description)")
        return file
    }
    
    //Opens the JSON File
    func openFile() -> String? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let path = paths[0]
        let filename = path.appendingPathComponent("Mealkit.json")
        let fileExists = FileManager().fileExists(atPath: filename.path)
        if fileExists == true {
            return filename.path;
        }
        else {
            return self.openDefaultFile()
        }
        return nil
    }
    
    //Reads data from JSON File and stores in array
    func getData(from file:String?) -> [Mealkit]? {
        if file == nil {
            print("File path is null")
            return nil
        }
        do {
            let jsonData = try String(contentsOfFile: file!).data(using: .utf8)
            print(jsonData!)         // outputs: Optional(749Bytes)
            let decodedData = try JSONDecoder().decode([Mealkit].self, from: jsonData!)
            dump(decodedData)
            return decodedData
        } catch {
            print("Error while parsing file")
            print(error)
        }
        return nil
    }
    
    //Searches if the user exists in database or not
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
    
    //Searches for meals; if they exists then it doesn't add from JSON file otherwise it will add into database
    func searchMeal() -> [Meal] {
        var meals:[Meal] = [Meal]()
        let request : NSFetchRequest<Meal> = Meal.fetchRequest()
        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let results = try db.fetch(request)
            meals = results
        }
        catch {
            print("Error searching for the data!!")
        }
        return meals
    }
    
    //Gets data from array and stores in database
    func saveData(meals:[Mealkit]) {
        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        for meal in meals {
            let mealo = Meal(context: db)
            mealo.id = Int16(meal.id)
            mealo.name = meal.name
            mealo.descriptions = meal.description
            mealo.price = meal.price
            mealo.image = meal.image
            mealo.calorieCount = meal.calorieCount
            do {
                try db.save()
            } catch  {
                print("Save Unsuccessful!!")
            }
        }
    }
}

