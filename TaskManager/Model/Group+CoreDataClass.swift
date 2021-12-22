//
//  Group+CoreDataClass.swift
//  TaskManager
//
//  Created by Aiden on 12/20/21.
//
//

import Foundation
import CoreData


public class Group: NSManagedObject {
    public override func awakeFromInsert() {
        self.backlogTasks = NSSet()
        self.dueTasks = NSSet()
        self.completedTasks = NSSet()
    }
}
