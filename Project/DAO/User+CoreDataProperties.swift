//
//  User+CoreDataProperties.swift
//  Project
//
//  Created by Dishant Patel on 2020-05-29.
//  Copyright © 2020 Dishant Patel. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String
    @NSManaged public var imageName: String
    @NSManaged public var password: String
    @NSManaged public var phoneNumber: Int64
    @NSManaged public var scratchCodes: NSSet
    @NSManaged public var order: Order

}

// MARK: Generated accessors for scratchCodes
extension User {

    @objc(addScratchCodesObject:)
    @NSManaged public func addToScratchCodes(_ value: ScratchCard)

    @objc(removeScratchCodesObject:)
    @NSManaged public func removeFromScratchCodes(_ value: ScratchCard)

    @objc(addScratchCodes:)
    @NSManaged public func addToScratchCodes(_ values: NSSet)

    @objc(removeScratchCodes:)
    @NSManaged public func removeFromScratchCodes(_ values: NSSet)

}

// MARK: Generated accessors for order
extension User {

    @objc(addOrderObject:)
    @NSManaged public func addToOrder(_ value: Order)

    @objc(removeOrderObject:)
    @NSManaged public func removeFromOrder(_ value: Order)

    @objc(addOrder:)
    @NSManaged public func addToOrder(_ values: NSSet)

    @objc(removeOrder:)
    @NSManaged public func removeFromOrder(_ values: NSSet)

}
