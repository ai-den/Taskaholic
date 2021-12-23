//
//  ViewController.swift
//  TaskManager
//
//  Created by Aiden on 30/11/2021.
//

import UIKit
import CoreData

//let groupColorNotificationKey = "com.aiden.GroupColor"

class GroupsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var groups = [Group]()
    var longPressRecognizer: UILongPressGestureRecognizer!


    override func viewDidLoad() {
        super.viewDidLoad()
        print("GroupsVC - viewDidLoad")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "GroupTableViewCell", bundle: nil), forCellReuseIdentifier: "groupCell")
        
        navigationController?.navigationBar.largeTitleTextAttributes = [      NSAttributedString.Key.font: UIFont(name: K.fonts.sfproRounded_SemiBold, size: 32)!]
        
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressedCell(_:)))
        longPressRecognizer.numberOfTouchesRequired = 1
        longPressRecognizer.allowableMovement = 10
        longPressRecognizer.minimumPressDuration = 0.5
        
        // Notificaiton Center
//        NotificationCenter.default.addObserver(self, selector: <#T##Selector#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
        print("GroupsVC - viewWillAppear")
        loadGroups()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NewGroupViewController {
            destination.context = self.context
            destination.delegate = self
        }
    }
    
    func saveGroups() {
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Error saving groups")
            print(error.localizedDescription)
        }
    }
    
    func loadGroups() {
        let request: NSFetchRequest<Group> = Group.fetchRequest()
        do {
            groups = try context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error fetching GROUP from core data.")
            print(error.localizedDescription)
        }
    }
    
    @objc func longPressedCell(_ sender: UILongPressGestureRecognizer) {
        print("cell long pressed")
    }
}


// MARK: - Table DataSource

extension GroupsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = groups[indexPath.row]
        let color = group.backgroundColor as! UIColor
        let groupCell = tableView.dequeueReusableCell(withIdentifier: K.cell.groupCell, for: indexPath) as! GroupTableViewCell
        
        groupCell.groupNameLabel.text = group.name
        groupCell.backgroundButton.backgroundColor = color
        groupCell.addGestureRecognizer(longPressRecognizer)

        return groupCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groupToRemove = groups[indexPath.row]
            context.delete(groupToRemove)
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            saveGroups()
            loadGroups()
        }
    }
}


// MARK: - Table Delegate

extension GroupsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        
        // Assign group value to send to tasksScene
        let tasksVC = storyboard?.instantiateViewController(withIdentifier: K.viewcontrollers.taskVC) as! TasksViewController
        tasksVC.group = groups[indexPath.row]
        tasksVC.context = self.context
        navigationController?.pushViewController(tasksVC, animated: true)
    }
}


// MARK: - Extensions

extension UIColor {
    func darker() -> UIColor {

        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0

        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }

        return UIColor()
    }

    func lighter() -> UIColor {

        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0

        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: min(r + 0.2, 1.0), green: min(g + 0.2, 1.0), blue: min(b + 0.2, 1.0), alpha: a)
        }

        return UIColor()
    }
}

extension GroupsViewController: NewGroupProtocol {
    func didAddNewGroup(with group: Group) {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        loadGroups()
    }
}



