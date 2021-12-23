//
//  NewTaskTableViewController.swift
//  TaskManager
//
//  Created by Aiden on 04/12/2021.
//

import UIKit
import GameplayKit
import TagListView

let priorityNotificationKey = "com.aiden.Priority"
let tagsNotificationKey = "com.aiden.Tags"

protocol NewTaskDelegate {
    
    func didSendTask(title: String,
                     description: String,
                     priority: Priority,
                     state: State,
                     labels: [Label],
                     dueDate: Date)
    
    func didUpdatetask(title: String, description: String, priority: Priority, state: State, labels: [Label], dueDate: Date, justFor task: Task)
}

class NewTaskTableViewController: UITableViewController {

    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var tagCell: UITableViewCell!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var dateCell: UITableViewCell!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeCell: UITableViewCell!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var parentTimeCell: UITableViewCell!
    @IBOutlet weak var parentBackgroundView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var addTagButton: UIButton!
    @IBOutlet weak var priorityCell: UITableViewCell!
    @IBOutlet weak var priorityLabel: UILabel!
    
    let priorityNotification = Notification.Name(rawValue: priorityNotificationKey)

    var delegate: NewTaskDelegate!
    var dueDate: Date!
    var priority: Priority!
    var isDateHidden: Bool = true
    var isTimeHidden: Bool = true
    var isFromDue: Bool = false
    var task: Task?
    var tagColor: UIColor!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        print("NewTaskView viewDidLoad()")
        if let task = task {
            titleTextField.text = task.title!
            descriptionTextView.text = task.context!
            dueDate = task.dueDate
            dateLabel.text = dueDate.getDateString(with: K.dateFomats.MMMdyyyyWithComma)
            timeLabel.text = dueDate.getDateString(with: K.dateFomats.hmma)
            for tag in task.tags?.allObjects as! [Tag] {
                tagListView.addTag(tag.name!)
            }
            
            priority = task.getPriority()
            print("Priority is not nil anymore.")
            print("value: \(priority.toString())")
            
            if task.dueTasksFromGroup != nil {
                isFromDue = true
                titleTextField.isUserInteractionEnabled = false
                descriptionTextView.isUserInteractionEnabled = false
                addTagButton.heightAnchor.constraint(equalToConstant: 0).isActive = true
                addTagButton.isHidden = true
                //tableView.layoutIfNeeded()
                tagListView.removeButtonIconSize = 0
                tagListView.removeIconLineWidth = 0
                dateCell.isUserInteractionEnabled = false
                timeCell.isUserInteractionEnabled = false
                priorityCell.isUserInteractionEnabled = false
                
            }
        } else {
            print("Priority becomes NONE.")
            dueDate = Date()
            priority = Priority.none
        }
        
        priorityLabel.text = priority.toString()

        // TextView placeholder
        descriptionTextView.placeholder = "Text Description"
        
        // Tag list config
        tagListView.delegate = self
        tagListView.textFont = UIFont.systemFont(ofSize: 20)
        tagListView.tagBackgroundColor = tagColor
        if tagListView.tagViews.isEmpty {
            //tagListView.heightAnchor.constraint(equalToConstant: 0).isActive = true
            tagListView.isHidden = true
        }
        
        // Tag cell config
        addTagButton.titleLabel?.font = UIFont(name: K.fonts.sfproRounded_SemiBold, size: 15)
        addTagButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 20)
        
        // Date & Time config
        datePicker.date = dueDate
        timePicker.date = dueDate
        
        dateLabel.text = dueDate.getDateString(with: K.dateFomats.MMMMdyyyyWithComma)
        timeLabel.text = dueDate.getDateString(with: K.dateFomats.hmma)
        
        // Notification Observer
        NotificationCenter.default.addObserver(self, selector: #selector(updatePriority(notification:)), name: priorityNotification, object: nil)
        
        // Keyboard dimiss mode already configured in layout inspector
        //tableView.keyboardDismissMode = .onDrag
        
    }

    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        let title = titleTextField.text!
        let taskDescription = descriptionTextView.text!
        let priority = priority!
        let dueDate = dueDate
        let state = determineState(by: dueDate!)
        var labels = [Label]()
        for tagView in tagListView.tagViews {
            let text = tagView.titleLabel!.text!
            labels.append(Label(name: text))
        }
        print("New Task State: \(state.rawValue)")
        print("New Task dueDate: \(dueDate!.getDateString(with: K.dateFomats.MMMMdyyyyWithComma))")
        
        if !titleTextField.text!.isEmpty  {
            if let task = task {
                delegate.didUpdatetask(title: title, description: taskDescription, priority: priority, state: state, labels: labels, dueDate: dueDate!, justFor: task)

            } else {
                delegate.didSendTask(title: title,
                                     description: taskDescription,
                                     priority: priority,
                                     state: state,
                                     labels: labels,
                                     dueDate: dueDate!)
            }
            
            self.dismiss(animated: true)
        }
    }
    
    // MARK: - Notification Methods

    @objc func updatePriority(notification: NSNotification) {
        let priorityString = notification.object as! String
        priority = getPriorityFrom(string: priorityString)
        let priorityCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3))
        priorityCell?.detailTextLabel?.text = priorityString
        print("Notification Observer object: \(priorityString)")
    }
    
    // MARK: - IBAction methods

    @IBAction func addTagClicked(_ sender: Any) {
        
        let alertController = UIAlertController(title: "What's a tag?", message: "Give your tag a name (without space will be cooler)", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let doneAction = UIAlertAction(title: "Done", style: .default) { [weak alertController] _ in
            guard let textFields = alertController?.textFields else { return }
            let tagName = textFields[0].text!
            if !tagName.isEmpty {
                print("Tag name with: \(tagName)")
                // Remove the height constraint
                //self.tagListView.heightAnchor.constraint(equalToConstant: 0).isActive = false
                self.tagListView.isHidden = false
                
                // Different animation in updating static cell
                // First approach (better)
                self.tagListView.addTag(tagName)
                self.tableView.reloadData()
                
                // Second approach
//                self.tableView.performBatchUpdates({
//                    self.tagListView.addTag(tagName)
//                }, completion: nil)
            }
        }
        
        doneAction.isEnabled = false
        
        // TextField
        alertController.addTextField { textField in
            textField.placeholder = "Tag name"
        }
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: alertController.textFields?[0], queue: OperationQueue.main) { (notification) in
            let tagName = alertController.textFields![0]
            doneAction.isEnabled = !tagName.text!.isEmpty
        }
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func dateValueChanged(_ sender: UIDatePicker) {
        print("date from dateValueChanged(_sender): \(sender.date.getDateString(with: K.dateFomats.MMMdhmma))")
        dueDate = sender.date
        timePicker.date = dueDate
        dateLabel.text = dueDate.getDateString(with: K.dateFomats.MMMdyyyyWithComma)
    }
    
    @IBAction func timeValueChanged(_ sender: UIDatePicker) {
        print("date from timeValueChanged(_sender): \(sender.date.getDateString(with: K.dateFomats.MMMdhmma))")
        dueDate = sender.date
        datePicker.date = dueDate
        timeLabel.text = dueDate.getDateString(with: K.dateFomats.hmma)
    }
    
    
    // MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PriorityTableViewController {
            let priorityString = priority!.toString()
            destination.selectedPriority = priorityString
        }
    }
              
}


// MARK: - TableView Delegate methods

extension NewTaskTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        let section = indexPath.section
        let row = indexPath.row
        
        // Priority Seletion
        if !isFromDue {
            if section == 3 {
                print("Priority selected")
                performSegue(withIdentifier: "toPriorityScene", sender: nil)
            } else if section == 2 {
                if row == 0 {
                    tableView.performBatchUpdates ({
                        self.isDateHidden = !isDateHidden
                        self.dateCell.isHidden = isDateHidden
                    }, completion: nil)
                } else if row == 2 {
                    tableView.performBatchUpdates ({
                        self.isTimeHidden = !isTimeHidden
                        self.timeCell.isHidden = isTimeHidden
                    }, completion: nil)
                }
            } else if section == 1 {
                addTagClicked(self)
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 2 && row == 1 {
            if isDateHidden == true {
                return 0
            }
        } else if section == 2 && row == 3 {
            if isTimeHidden == true {
                parentBackgroundView.roundBottomCorners(radius: 10)
                return 0
            } else {
                parentBackgroundView.roundBottomCorners(radius: 0)
            }
        } else if section == 3 && row == 0 {
            return 50
        }
        return UITableView.automaticDimension
        //return super.tableView(tableView, heightForRowAt: indexPath)
    }
}

// MARK: - TaglistView Delegate

extension NewTaskTableViewController: TagListViewDelegate {
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tableView.performBatchUpdates({
            sender.removeTagView(tagView)
        }, completion: nil)
        
    }
}





