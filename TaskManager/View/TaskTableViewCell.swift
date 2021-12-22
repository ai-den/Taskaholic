//
//  TaskTableViewCell.swift
//  TaskManager
//
//  Created by Aiden on 07/12/2021.
//

import UIKit
import TagListView

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueTimeLabel: UILabel!
    @IBOutlet weak var priorityIndicator: UIButton!
    @IBOutlet weak var taskStatusLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    
    var state: State!
    var buttonClickCallBack: ((Bool) -> Void) = {_ in}
    
    override func awakeFromNib() {
        super.awakeFromNib()

        checkButton.setTitle("", for: .normal)
        priorityIndicator.setTitle("", for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func didCheckButton(_ sender: Any) {
        buttonClickCallBack(true)
    }
}
