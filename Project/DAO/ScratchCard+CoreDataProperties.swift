//
//  ScratchCard+CoreDataProperties.swift
//  Project
//
//  Created by Dishant Patel on 2020-05-30.
//  Copyright © 2020 Dishant Patel. All rights reserved.
//
//

import Foundation
import CoreData


extension ScratchCard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScratchCard> {
        return NSFetchRequest<ScratchCard>(entityName: "ScratchCard")
    }

    @NSManaged public var discount: Int16
    @NSManaged public var isUsed: Bool
    @NSManaged public var scratchCardCode: String
    @NSManaged public var user: User

}
