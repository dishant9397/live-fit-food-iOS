//
//  OrderSummaryViewController.swift
//  Project
//
//  Created by Dishant Patel on 2020-05-31.
//  Copyright © 2020 Dishant Patel. All rights reserved.
//

import UIKit

class OrderSummaryViewController: UIViewController {

    //MARK-OUTLETS
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var discountLabel: UILabel!
    @IBOutlet var tipLabel: UILabel!
    @IBOutlet var taxLabel: UILabel!
    @IBOutlet var subTotalLabel: UILabel!
    
    //MARK-VARIABLES
    var order:Order = Order()
   
    //MAIN FUNCTION
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: order.meal.image)
        nameLabel.text = order.meal.name
        priceLabel.text = "$" + String(format: "%.2f", order.meal.price)
        discountLabel.text = "$" + String(format: "%.2f", order.discount)
        tipLabel.text = "$" + String(format: "%.2f", order.tip)
        taxLabel.text = "$" + String(format: "%.2f", order.tax)
        subTotalLabel.text = "$" + String(format: "%.2f", order.subTotal)
    }
}
