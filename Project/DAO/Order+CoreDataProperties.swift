//
//  Order+CoreDataProperties.swift
//  Project
//
//  Created by Dishant Patel on 2020-06-01.
//  Copyright © 2020 Dishant Patel. All rights reserved.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var discount: Double
    @NSManaged public var subTotal: Double
    @NSManaged public var tax: Double
    @NSManaged public var tip: Double
    @NSManaged public var date: Date
    @NSManaged public var meal: Meal
    @NSManaged public var user: User

}
