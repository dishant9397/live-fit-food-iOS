//
//  MenuViewController.swift
//  Project
//
//  Created by Dishant Patel on 2020-05-26.
//  Copyright © 2020 Dishant Patel. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK-OUTLETS
    @IBOutlet var mealTableView: UITableView!
    
    //MARK-VARIABLES
    var meals:[Meal] = [Meal]()
    
    //MAIN FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mealTableView.delegate = self
        self.mealTableView.dataSource = self
        meals = getData()
        mealTableView.rowHeight = 129
    }
    
    //Function to count number of rows in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    //Function to show content in each row of table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "mealCell") as! MealTableViewCell
        if cell == nil {
            cell = MealTableViewCell (
            style: UITableViewCell.CellStyle.default, reuseIdentifier: "mealCell")
        }
        cell.mealNameLabel.text = meals[indexPath.row].name + " Package"
        cell.mealImageView.image = UIImage(named: meals[indexPath.row].image)
        cell.mealDescriptionLabel.text = meals[indexPath.row].descriptions
        cell.mealPriceLabel.text = "$: " +  String(meals[indexPath.row].price)
        cell.mealCalorieCountLabel.text = String(meals[indexPath.row].calorieCount) + " Calories"
        return cell
    }
    
    //Function that performs when user clicks on particular row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let defaults = UserDefaults.standard
        defaults.set(meals[indexPath.row].id, forKey: "mealId")
    }
    
    //Function to get data from database
    func getData() -> [Meal] {
        var meals:[Meal] = [Meal]()
        let request : NSFetchRequest<Meal> = Meal.fetchRequest()
        let db = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            let results = try db.fetch(request)
            if results.count == 0 {
                print("No results found!!")
            }
            else {
                meals = results
            }
        }
        catch {
            print("Error searching for the data!!")
        }
        return meals
    }

}
