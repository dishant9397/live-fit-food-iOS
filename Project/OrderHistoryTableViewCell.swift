//
//  OrderHistoryTableViewCell.swift
//  Project
//
//  Created by Dishant Patel on 2020-06-01.
//  Copyright © 2020 Dishant Patel. All rights reserved.
//

import UIKit

class OrderHistoryTableViewCell: UITableViewCell {

    //MARK-OUTLETS
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var discountLabel: UILabel!
    @IBOutlet var tipLabel: UILabel!
    @IBOutlet var taxLabel: UILabel!
    @IBOutlet var subTotalLabel: UILabel!
    
    //MAIN FUNCTION
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //Function when particular item from Table is selected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
