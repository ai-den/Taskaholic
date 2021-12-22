//
//  CheckButton.swift
//  TaskManager
//
//  Created by Aiden on 07/12/2021.
//

import Foundation
import UIKit

//protocol CheckButtonDelegate {
//    func didChangeState(from origin: State, to new: State)
//}

class CheckButton: UIButton {
    
    var checkedImage = UIImage(systemName: "checkmark.circle.fill")!
    var uncheckedImage = UIImage(systemName: "circle")!
    
    var isChecked: Bool = false {
        didSet {
            if isChecked {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
}
