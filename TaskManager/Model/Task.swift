//
//  Task.swift
//  TaskManager
//
//  Created by Aiden on 01/12/2021.
//

import Foundation

class Task {
    var title: String = ""
    var description: String = ""
    var tags: [Tag] = []
    var priority: Priority = .none
    var state: State = .normal
    var createdDateTime: Date = Date()
    var dueDateTime: Date?
    var completedDateTime: Date?
    
    init(title: String, description: String, priority: Priority = .none, dueDateTime: Date) {
        self.title = title
        self.description = description
        self.priority = priority
        self.dueDateTime = dueDateTime
    }
    
    func isDue() -> Bool {
        let currentDate = Date()
        if currentDate > dueDateTime! {
            state = .due
            return true
        }
        return false
    }
}
