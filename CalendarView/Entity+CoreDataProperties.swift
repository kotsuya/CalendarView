//
//  Entity+CoreDataProperties.swift
//  CalendarView
//
//  Created by YooSeunghwan on 2018/02/02.
//  Copyright © 2018年 eys-style. All rights reserved.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var updateDate: NSDate?
    @NSManaged public var sentence: String?
    @NSManaged public var index: Int64

}
