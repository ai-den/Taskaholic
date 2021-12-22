//
//  K.swift
//  TaskManager
//
//  Created by Aiden on 02/12/2021.
//

import Foundation

struct K {
    struct cell {
        static let groupCell = "groupCell"
        static let taskCell = "taskCell"
    }
    
    struct fonts {
        static let sfproRounded_Bold = "SFProRounded-Bold"
        static let sfproRounded_Regular = "SFProRounded-Regular"
        static let sfproRounded_Medium = "SFProRounded-Medium"
        static let sfproRounded_SemiBold = "SFProRounded-Semibold"
    }
    
    struct segues {
        static let toNewGroupScene = "toNewGroupScene"
        static let toGroupScene = "toGroupScene"
        static let toTaskScene = "toTaskScene"
        static let toNewTaskScene = "toNewTaskScene"
        static let toUpdateTaskScene = "toUpdateTaskScene"
    }
    
    struct viewcontrollers {
        static let taskVC = "taskScene"
        static let newTaskVC = "newTaskVCd"
    }
    
    //AVAILABLE STRING FORMATS FOR DATEFORMAT
    
    // Wednesday, Sep 12, 2018           --> EEEE, MMM d, yyyy
    // 09/12/2018                        --> MM/dd/yyyy
    // 09-12-2018 14:11                  --> MM-dd-yyyy HH:mm
    // Sep 12, 2:11 PM                   --> MMM d, h:mm a
    // September 2018                    --> MMMM yyyy
    // Sep 12, 2018                      --> MMM d, yyyy
    // Wed, 12 Sep 2018 14:11:54 +0000   --> E, d MMM yyyy HH:mm:ss Z
    // 2018-09-12T14:11:54+0000          --> yyyy-MM-dd'T'HH:mm:ssZ
    // 12.09.18                          --> dd.MM.yy
    // 10:41:02.112                      --> HH:mm:ss.SSS
    struct dateFomats {
        static let MMMdyyyyWithComma = "MMM d, yyyy"
        static let MMMMdyyyyWithComma = "MMMM d, yyyy"
        static let MMMdhmma = "MMM d, h:mm a"
        static let hmma = "h:mm a"
        static let MMMdyyyyhmma = "MMM d, yyyy h:mm a"
    }
}
