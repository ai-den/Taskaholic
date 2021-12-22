//
//  Group+CoreDataProperties.swift
//  TaskManager
//
//  Created by Aiden on 12/20/21.
//
//

import Foundation
import CoreData


extension Group {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: "Group")
    }

    @NSManaged public var backgroundColor: NSObject?
    @NSManaged public var creationDate: Date?
    @NSManaged public var name: String?
    @NSManaged public var backlogTasks: NSSet?
    @NSManaged public var completedTasks: NSSet?
    @NSManaged public var dueTasks: NSSet?

}

// MARK: Generated accessors for backlogTasks
extension Group {

    @objc(addBacklogTasksObject:)
    @NSManaged public func addToBacklogTasks(_ value: Task)

    @objc(removeBacklogTasksObject:)
    @NSManaged public func removeFromBacklogTasks(_ value: Task)

    @objc(addBacklogTasks:)
    @NSManaged public func addToBacklogTasks(_ values: NSSet)

    @objc(removeBacklogTasks:)
    @NSManaged public func removeFromBacklogTasks(_ values: NSSet)

}

// MARK: Generated accessors for completedTasks
extension Group {

    @objc(addCompletedTasksObject:)
    @NSManaged public func addToCompletedTasks(_ value: Task)

    @objc(removeCompletedTasksObject:)
    @NSManaged public func removeFromCompletedTasks(_ value: Task)

    @objc(addCompletedTasks:)
    @NSManaged public func addToCompletedTasks(_ values: NSSet)

    @objc(removeCompletedTasks:)
    @NSManaged public func removeFromCompletedTasks(_ values: NSSet)

}

// MARK: Generated accessors for dueTasks
extension Group {

    @objc(addDueTasksObject:)
    @NSManaged public func addToDueTasks(_ value: Task)

    @objc(removeDueTasksObject:)
    @NSManaged public func removeFromDueTasks(_ value: Task)

    @objc(addDueTasks:)
    @NSManaged public func addToDueTasks(_ values: NSSet)

    @objc(removeDueTasks:)
    @NSManaged public func removeFromDueTasks(_ values: NSSet)

}

extension Group : Identifiable {

}
