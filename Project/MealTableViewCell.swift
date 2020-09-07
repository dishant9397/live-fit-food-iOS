//
//  MealTableViewCell.swift
//  Project
//
//  Created by Dishant Patel on 2020-05-26.
//  Copyright © 2020 Dishant Patel. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    //MARK-OUTLETS
    @IBOutlet var mealImageView: UIImageView!
    @IBOutlet var mealNameLabel: UILabel!
    @IBOutlet var mealDescriptionLabel: UILabel!
    @IBOutlet var mealCalorieCountLabel: UILabel!
    @IBOutlet var mealPriceLabel: UILabel!
    
    //MAIN FUNCTION
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //Function when particular item from Table is selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
