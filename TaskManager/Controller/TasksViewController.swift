//
//  TasksViewController.swift
//  TaskManager
//
//  Created by Aiden on 02/12/2021.
//

import UIKit
import CoreData
import TagListView

class TasksViewController: UIViewController {

    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let checkedImage = UIImage(systemName: "checkmark.circle.fill")!
    let uncheckedImage = UIImage(systemName: "circle")!
    
    var context: NSManagedObjectContext!
    var group: Group! {
        didSet {
            if segmentedControl != nil {
                self.segmentValueChanged(segmentedControl)
                taskTableView.reloadData()
            } else {
                currentTasks = group.backlogTasks?.allObjects as! [Task]
            }
        }
    }
    var currentTasks = [Task]()
    var selectedTask: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentedControl.selectedSegmentIndex = 1
        
        navigationItem.title = group.name
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : group.backgroundColor as! UIColor,
            NSAttributedString.Key.font: UIFont(name: K.fonts.sfproRounded_Medium, size: 32)!]

        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.estimatedRowHeight = 170
        taskTableView.rowHeight = UITableView.automaticDimension
        taskTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: K.cell.taskCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentTasks = group.dueTasks?.allObjects as! [Task]
        case 1:
            currentTasks = group.backlogTasks?.allObjects as! [Task]
        case 2:
            currentTasks = group.completedTasks?.allObjects as! [Task]
        default:
            currentTasks = []
        }
        taskTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.toNewTaskScene {
            if let navigationController = segue.destination as? UINavigationController {
                let destination = navigationController.viewControllers.first as! NewTaskTableViewController
                destination.delegate = self
                destination.tagColor = group.backgroundColor as! UIColor
            }
        } else if segue.identifier == K.segues.toUpdateTaskScene {
            if let navigationController = segue.destination as? UINavigationController {
                let destination = navigationController.viewControllers.first as! NewTaskTableViewController
                guard let selectedTask = selectedTask else {
                    return
                }
                
                destination.delegate = self
                destination.task = selectedTask
                destination.tagColor = group.backgroundColor as! UIColor
                destination.title = "Edit Task"
            }
        }
    }
}

// MARK: - Table Delegate
extension TasksViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedTask = currentTasks[indexPath.row]
        performSegue(withIdentifier: K.segues.toUpdateTaskScene, sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskToRemove = currentTasks[indexPath.row]
            context.delete(taskToRemove)
            currentTasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            saveTasks()
            loadTasks()
        }
    }
}

// MARK: - NewTaskDelegate
extension TasksViewController: NewTaskDelegate {
    func didSendTask(title: String, description: String, priority: Priority, state: State, labels: [Label], dueDate: Date) {
        print("======== Add new Task ============")
        print("title: \(title)")
        print("description: \(description)")
        print("priority: \(priority.rawValue)")
        print("state: \(state.rawValue)")
        print("duedate: \(dueDate.description)")
        print("============================")
        let newTask = Task(context: context)
        newTask.title = title
        newTask.context = description
        newTask.priority = Int64(exactly: priority.rawValue)!
        newTask.creationDate = Date()
        newTask.dueDate = dueDate
//        var tagSet = NSSet(array: <#T##[Any]#>)
//        var tagArray: [Tag] = []
        for label in labels {
            let tag = Tag(context: context)
            tag.name = label.name
            tag.color = group.backgroundColor as! UIColor
            tag.tagFromTask = newTask
        }
        
        newTask.state = state.rawValue
        switch state {
        case .normal:
            newTask.backlogTaskFromGroup = group
        case .due:
            newTask.dueTasksFromGroup = group
        case .completed:
            newTask.completedTasksFromGroup = group
        }
        saveTasks()
        loadTasks()
    }
    
    func didUpdatetask(title: String, description: String, priority: Priority, state: State, labels: [Label], dueDate: Date, justFor task: Task) {
        print("======== Update a Task ============")
        print("title: \(title)")
        print("description: \(description)")
        print("priority: \(priority.rawValue)")
        print("state: \(state.rawValue)")
        print("duedate: \(dueDate.description)")
        print("============================")
        task.title = title
        task.context = description
        task.priority = Int64(exactly: priority.rawValue)!
        task.creationDate = Date()
        task.dueDate = dueDate
        task.tags = nil
        for label in labels {
            let tag = Tag(context: context)
            tag.name = label.name
            tag.color = group.backgroundColor as! UIColor
            tag.tagFromTask = task
        }
        
        if selectedTask?.state != state.rawValue {
            print("States are not equal")
            task.state = state.rawValue
            switch state {
            case .normal:
                task.backlogTaskFromGroup = group
                task.dueTasksFromGroup = nil
                task.completedTasksFromGroup = nil
            case .due:
                task.backlogTaskFromGroup = nil
                task.dueTasksFromGroup = group
                task.completedTasksFromGroup = nil
            case .completed:
                task.backlogTaskFromGroup = nil
                task.dueTasksFromGroup = nil
                task.completedTasksFromGroup = group
            }
        } else {
            print("States are equal!")
        }
        
        saveTasks()
        loadTasks()
    }
    
}



// MARK: - Table Datasource
extension TasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let taskCell = tableView.dequeueReusableCell(withIdentifier: K.cell.taskCell, for: indexPath) as! TaskTableViewCell
        let task = currentTasks[indexPath.row]
        let priority = task.getPriority()
        var tagViews = [TagView]()
        taskCell.tagListView.isHidden = true
        taskCell.tagListView.removeAllTags()
        taskCell.tagListView.tagBackgroundColor = group.backgroundColor as! UIColor
        if let tags = task.tags?.allObjects as? [Tag] {
            if !tags.isEmpty {
                taskCell.tagListView.isHidden = false
                print("Not empty at: \(indexPath.row)")
                for tag in tags {
                    let tagName = tag.name!
                    print("tag: \(tagName)")
                    let tagView = TagView(title: tagName)
                    tagView.tagBackgroundColor = group.backgroundColor as! UIColor
                    tagViews.append(tagView)
                    taskCell.tagListView.addTag(tagName)
                }
            }
        }
//        DispatchQueue.main.async {
//            taskCell.tagListView.addTagViews(tagViews)
//        }
//        tableView.performBatchUpdates({
//
//        }, completion: nil)
                
        switch priority {
        case .none: taskCell.priorityIndicator.setImage(nil, for: .normal)
        default: taskCell.priorityIndicator.setImage(UIImage(systemName: priority.getImageString()), for: .normal)
        }
        
        var state = task.getState()
        if state != .completed {
            let newState = determineState(by: task.dueDate!)
            if state != newState {
                state = newState
                task.state = state.rawValue
                changeGroup(of: task, using: state)
                currentTasks.remove(at: indexPath.row)
                loadTasks()
            }
        }
        
        /*
            Configuring cells' appearance
         */
        print("going into switch statements now...")
        var stateImage = uncheckedImage
        switch state {
        case .normal:
            print("normal cell")
            stateImage = uncheckedImage
            taskCell.checkButton.isUserInteractionEnabled = true
            taskCell.taskStatusLabel.isHidden = true
        case .completed:
            print("completed cell")
            stateImage = checkedImage
            taskCell.checkButton.isUserInteractionEnabled = true
            taskCell.taskStatusLabel.isHidden = false
            taskCell.taskStatusLabel.text = state.toString()
            taskCell.taskStatusLabel.textColor = .systemGreen
            taskCell.taskStatusLabel.font = UIFont(name: K.fonts.sfproRounded_SemiBold, size: 17)
        case .due:
            print("due cell")
            taskCell.checkButton.isUserInteractionEnabled = false
            taskCell.taskStatusLabel.isHidden = false
            taskCell.taskStatusLabel.text = state.toString()
            taskCell.taskStatusLabel.textColor = .systemRed
            taskCell.taskStatusLabel.font = UIFont(name: K.fonts.sfproRounded_SemiBold, size: 17)
        }
        
        taskCell.checkButton.tintColor = group.backgroundColor as! UIColor
        DispatchQueue.main.async {
            taskCell.checkButton.setImage(stateImage, for: .normal)
        }
        
        
        /*
            Check button clicked callback
        */
        taskCell.buttonClickCallBack = { (param) in
            print("buttonClickCallBack")
            print("old state: \(state)")
            state = self.alterState(state: state)
            print("new state: \(state)")
            var newImage: UIImage? = nil
            switch state {
            case .normal:
                newImage = self.uncheckedImage
                task.completedTasksFromGroup = nil
                task.backlogTaskFromGroup = self.group
                print("task has become NORMAL ")
            case .due:
                //taskCell.checkButton.isHidden = true
                print("task has been DUE")
            case .completed:
                newImage = self.checkedImage
                task.backlogTaskFromGroup = nil
                task.completedTasksFromGroup = self.group
                print("task has been COMPLETED")
            }
            taskCell.checkButton.setImage(newImage, for: .normal)
            task.state = state.rawValue
            self.loadTasks()
            
//            DispatchQueue.main.async {
//                tableView.reloadData()
//            }
        }
        
        taskCell.taskLabel.text = task.title!
        taskCell.dueDateLabel.text = task.dueDate!.getDateString(with: K.dateFomats.MMMdyyyyWithComma)
        taskCell.dueTimeLabel.text = task.dueDate!.getDateString(with: K.dateFomats.hmma)
        return taskCell
    }
    
    func alterState(state: State) -> State {
        switch state {
        case .normal:
            return .completed
        case .completed:
            return .normal
        default:
            return .normal
        }
    }
    
    func changeGroup(of task: Task, using state: State) {
        switch state {
        case .normal:
            task.backlogTaskFromGroup = group
            task.dueTasksFromGroup = nil
            task.completedTasksFromGroup = nil
        case .due:
            task.backlogTaskFromGroup = nil
            task.dueTasksFromGroup = group
            task.completedTasksFromGroup = nil
        case .completed:
            task.backlogTaskFromGroup = nil
            task.dueTasksFromGroup = nil
            task.completedTasksFromGroup = group
        }
        saveTasks()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: - Core Data operations
extension TasksViewController {
    
    func saveTasks() {
        do {
            try context.save()
            taskTableView.reloadData()
        } catch {
            print("Error saving tasks")
            print(error.localizedDescription)
        }
    }
    
    func loadTasks() {
        let request: NSFetchRequest<Group> = Group.fetchRequest()
        let predicate = NSPredicate(format: "self == %@", group.objectID)
        request.predicate = predicate
        do {
            group = try context.fetch(request)[0]
            taskTableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkTasks() {
        
    }
}

