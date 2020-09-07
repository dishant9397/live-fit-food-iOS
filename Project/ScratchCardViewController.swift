//
//  ScratchCardViewController.swift
//  Project
//
//  Created by Dishant Patel on 2020-05-29.
//  Copyright © 2020 Dishant Patel. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ScratchCardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK-OUTLETS
    @IBOutlet var couponLabel: UILabel!
    @IBOutlet var couponCodeLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    //MARK-VARIABLES
    var user:User?
    var motionCount = 0
    var scratchCards:[ScratchCard] = [ScratchCard]()
    var scratchCardsTable:[ScratchCard] = [ScratchCard]()

    //MAIN FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let defaults = UserDefaults.standard
        user = searchUser(email: defaults.string(forKey: "email")!)
        scratchCardsTable = searchScratchCardByUser(user: user!)
    }
    
    //Function refreshes table data when tab changes
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        user = searchUser(email: defaults.string(forKey: "email")!)
        scratchCardsTable = searchScratchCardByUser(user: user!)
        tableView.reloadData()
    }
    
    //Funtion which executes when user shakes phone
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if checkEligibility() {
            motionCount += 1
            if motionCount == 3 {
                motionCount = 0
                while true {
                    let percent = generateProbability()
                    if percent == "00" {
                        let box = UIAlertController(
                            title: "No Scratch Card",
                            message: "Sorry!! You have not won any scratch card",
                            preferredStyle: .alert
                        )
                        box.addAction(
                            UIAlertAction(title:"OK", style: .default, handler:nil)
                        )
                        self.present(box, animated:true)
                        break
                    }
                    else {
                        let scratchCardCode = "GET" + percent + "DISCOUNT" + String(Int.random(in: 100000000...999999999))
                        scratchCards = searchScratchCardByCode(scratchCardCode: scratchCardCode)
                        if scratchCards.count == 0 {
                            addScratchCard(discount: Int16(percent)! ,user: user!, scratchCardCode: scratchCardCode)
                            couponLabel.text = "Your Coupon Code : "
                            couponCodeLabel.text = scratchCardCode
                            tableView.reloadData()
                            break
                        }
                    }
                }
            }
        }
        else {
            let box = UIAlertController(
                title: "Invalid motion",
                message: "Sorry!! This is not time to win a scratch card",
                preferredStyle: .alert
            )
            box.addAction(
                UIAlertAction(title:"OK", style: .default, handler:nil)
            )
            self.present(box, animated:true)
        }
    }
    
    //Returns number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scratchCardsTable.count
    }
    
    //Displays the content in each table cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "scratchCardCell")
        if cell == nil {
            cell = UITableViewCell (
            style: UITableViewCell.CellStyle.default, reuseIdentifier: "scratchCardCell")
        }
        if scratchCardsTable[indexPath.row].isUsed == true {
            cell?.textLabel?.text = scratchCardsTable[indexPath.row].scratchCardCode + "\t\t Expired"
            cell?.textLabel?.textColor = UIColor.red
        }
        else {
            cell?.textLabel?.text = scratchCardsTable[indexPath.row].scratchCardCode + "\t\t Active"
            cell?.textLabel?.textColor = UIColor.green
        }
        return cell!
    }
    
    //Adds coupon code to datase
    func addScratchCard(discount:Int16, user:User, scratchCardCode:String) {
        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let scratchCard = ScratchCard(context: db)
        scratchCard.discount = discount
        scratchCard.user = user
        scratchCard.scratchCardCode = scratchCardCode
        scratchCard.isUsed = false
        do {
            try db.save()
            let box = UIAlertController(
                title: "Congratulations",
                message: "You have won a scratch card",
                preferredStyle: .alert
            )
            box.addAction(
                UIAlertAction(title:"OK", style: .default, handler:nil)
            )
            self.present(box, animated:true)
        } catch  {
            print("Save Unsuccessful!!")
        }
    }
    
    //Function to search scratch card by specific user
    func searchScratchCardByUser(user:User) -> [ScratchCard] {
        var scratchCards:[ScratchCard] = [ScratchCard]()
        let request : NSFetchRequest<ScratchCard> = ScratchCard.fetchRequest()
        let query = NSPredicate(format: "user == %@", user)
        request.predicate = query
        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let results = try db.fetch(request)
            if results.count == 0 {
                print("No results found!!")
            }
            else {
                scratchCards = results
            }
        }
        catch {
            print("Error searching for the data!!")
        }
        return scratchCards
    }
    
    //Function to search scratch card by code
    func searchScratchCardByCode(scratchCardCode:String) -> [ScratchCard] {
        var scratchCards:[ScratchCard] = [ScratchCard]()
        let request : NSFetchRequest<ScratchCard> = ScratchCard.fetchRequest()
        let query = NSPredicate(format: "scratchCardCode == %@", scratchCardCode)
        request.predicate = query
        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let results = try db.fetch(request)
            if results.count == 0 {
                print("No results found!!")
            }
            else {
                scratchCards = results
            }
        }
        catch {
            print("Error searching for the data!!")
        }
        return scratchCards
    }

    //Function searchs for user from database
    func searchUser(email:String) -> User {
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
        return users[0]
    }
    
    //Function generates probability
    func generateProbability() -> String {
        let numbers = [1, 6, 6, 6, 6, 6, 6, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13]
        let number = Int.random(in: 0...19)
        if numbers[number] == 1 {
           return "50"
        }
        else if numbers[number] == 6 {
          return "10"
        }
        else {
            return "00"
        }
    }
    
    //Function checks if user is eligible to opt for an offer or not
    //I have kept 6PM to 7PM for users to opt in this period
    func checkEligibility() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        if dateFormatter.string(from: Date()) == "18" {
            return true
        }
        else {
            return false
        }
        return true
    }
}
