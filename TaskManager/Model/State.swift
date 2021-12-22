//
//  State.swift
//  TaskManager
//
//  Created by Aiden on 01/12/2021.
//

import UIKit
import GameplayKit

enum State: Int64 {
    case due, normal, completed
    
    func toString() -> String {
        switch self.rawValue {
        case 0: return "DUE"
        case 1: return "Normal"
        case 2: return "Completed"
        default: return "NaN"
        }
    }
}

func determineState(by dueDate: Date) -> State {
    if dueDate < Date() {
        print("determineState result: DUE")
        return .due
    } else {
        print("determineState result: Normal")
        return .normal
    }
}
