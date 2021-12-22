//
//  Priority.swift
//  TaskManager
//
//  Created by Aiden on 01/12/2021.
//

import GameplayKit

enum Priority: Int64 {
    case none
    case low
    case medium
    case high
    
    func toString() -> String {
        switch self.rawValue {
        case 0: return "None"
        case 1: return "Low"
        case 2: return "Medium"
        case 3: return "High"
        default: return "None"
        }
    }
    
    func getImageString() -> String {
        switch self.rawValue {
        case 0: return "none"
        case 1: return "exclamationmark"
        case 2: return "exclamationmark.2"
        case 3: return "exclamationmark.3"
        default: return "none"
        }
    }
}

func getPriorityFrom(string priorityString: String) -> Priority {
    switch priorityString {
    case "None": return .none
    case "Low": return .low
    case "Medium": return .medium
    case "High": return .high
    default: return .none
    }
}

