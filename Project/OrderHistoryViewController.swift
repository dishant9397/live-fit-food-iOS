//
//  OrderHistoryViewController.swift
//  Project
//
//  Created by Dishant Patel on 2020-05-29.
//  Copyright © 2020 Dishant Patel. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class OrderHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK-OUTLETS
    @IBOutlet var tableView: UITableView!
    
    //MARK-VARIABLES
    var orders:[Order] = [Order]()
    var user:User = User()
    
    //MAIN FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let defaults = UserDefaults.standard
        user = searchUser(email: defaults.string(forKey: "email")!)
        orders = searchOrders(user: user)
        tableView.rowHeight = 131
    }
    
    //Function refreshes table data when tab changes
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        user = searchUser(email: defaults.string(forKey: "email")!)
        orders = searchOrders(user: user)
        tableView.reloadData()
    }
    
    //Function that refreshs the data when user comes back on this screen again for any changes
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    //Function returns number of row from database
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    //Function returns content in each row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "orderHistoryCell") as! OrderHistoryTableViewCell
        if cell == nil {
            cell = OrderHistoryTableViewCell (
            style: UITableViewCell.CellStyle.default, reuseIdentifier: "orderHistoryCell")
        }
        cell.nameLabel.text = "Name: " + orders[indexPath.row].meal.name + " Package"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-YYYY"
        cell.dateLabel.text = dateFormatter.string(from: orders[indexPath.row].date)
        cell.discountLabel.text = "Discount: $" + String(format: "%.2f", orders[indexPath.row].discount)
        cell.tipLabel.text = "Tip: $" + String(format: "%.2f", orders[indexPath.row].tip)
        cell.taxLabel.text = "Tax: $" + String(format: "%.2f", orders[indexPath.row].tax)
        cell.subTotalLabel.text = "Total: $" + String(format: "%.2f", orders[indexPath.row].subTotal)
        return cell
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
    
    //Function searchs for orders from database
    func searchOrders(user:User) -> [Order] {
        var orders:[Order] = [Order]()
        let request : NSFetchRequest<Order> = Order.fetchRequest()
        let query = NSPredicate(format: "user == %@", user)
        request.predicate = query
        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let results = try db.fetch(request)
            orders = results
        }
        catch {
            print("Error searching for the data!!")
        }
        return orders
    }
}
