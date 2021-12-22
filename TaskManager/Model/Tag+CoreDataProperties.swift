//
//  Tag+CoreDataProperties.swift
//  TaskManager
//
//  Created by Aiden on 19/12/2021.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var color: NSObject?
    @NSManaged public var name: String?
    @NSManaged public var tagFromTask: Task?

}

extension Tag : Identifiable {

}
