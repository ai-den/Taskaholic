//
//  Task+CoreDataProperties.swift
//  TaskManager
//
//  Created by Aiden on 13/12/2021.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var context: String?
    @NSManaged public var creationDate: Date?
    @NSManaged public var dueDate: Date?
    @NSManaged public var priority: Int64
    @NSManaged public var state: Int64
    @NSManaged public var title: String?
    @NSManaged public var tags: NSSet?
    @NSManaged public var backlogTaskFromGroup: Group?
    @NSManaged public var dueTasksFromGroup: Group?
    @NSManaged public var completedTasksFromGroup: Group?

}

// MARK: Generated accessors for tags
extension Task {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

extension Task : Identifiable {

}
