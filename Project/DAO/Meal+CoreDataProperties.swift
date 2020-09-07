//
//  Meal+CoreDataProperties.swift
//  Project
//
//  Created by Dishant Patel on 2020-05-29.
//  Copyright © 2020 Dishant Patel. All rights reserved.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var calorieCount: Double
    @NSManaged public var descriptions: String
    @NSManaged public var id: Int16
    @NSManaged public var image: String
    @NSManaged public var name: String
    @NSManaged public var price: Double
    @NSManaged public var order: Order

}

// MARK: Generated accessors for order
extension Meal {

    @objc(addOrderObject:)
    @NSManaged public func addToOrder(_ value: Order)

    @objc(removeOrderObject:)
    @NSManaged public func removeFromOrder(_ value: Order)

    @objc(addOrder:)
    @NSManaged public func addToOrder(_ values: NSSet)

    @objc(removeOrder:)
    @NSManaged public func removeFromOrder(_ values: NSSet)

}
