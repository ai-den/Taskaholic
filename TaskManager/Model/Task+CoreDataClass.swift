//
//  Task+CoreDataClass.swift
//  TaskManager
//
//  Created by Aiden on 13/12/2021.
//
//

import Foundation
import CoreData


public class Task: NSManagedObject {
    
    func getPriority() -> Priority {
        return Priority(rawValue: self.priority)!
    }
    
    func getState() -> State {
        return State(rawValue: self.state)!
    }
    
    func isDue() -> Bool {
        if dueDate! < Date() {
            return true
        } else {
            return false
        }
    }
}
