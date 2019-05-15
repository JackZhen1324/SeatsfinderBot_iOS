//
//  Entity+CoreDataProperties.swift
//  
//
//  Created by ZhenQian on 5/12/19.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var courseID: String?
    @NSManaged public var courseName: String?
    @NSManaged public var instructorInfo: String?
    @NSManaged public var courseTerm: String?
    @NSManaged public var coutseTime: String?
    @NSManaged public var courseStatus: String?
    @NSManaged public var courseTitle: String?

}
