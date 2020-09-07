//
//  Mealkit.swift
//  Project
//
//  Created by Dishant Patel on 2020-05-26.
//  Copyright © 2020 Dishant Patel. All rights reserved.
//

import Foundation

struct Mealkit:Codable {
    var id:Int = 0
    var name:String = ""
    var description:String = ""
    var price:Double = 0.0
    var image:String = ""
    var calorieCount:Double = 0.0
    
    init() {}
}
