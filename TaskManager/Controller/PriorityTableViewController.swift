//
//  PriorityTableViewController.swift
//  TaskManager
//
//  Created by Aiden on 17/12/2021.
//

import UIKit

class PriorityTableViewController: UITableViewController {

    @IBOutlet weak var nonePriorityCell: UITableViewCell!
    @IBOutlet weak var lowPriorityCell: UITableViewCell!
    @IBOutlet weak var mediumPriorityCell: UITableViewCell!
    @IBOutlet weak var highPriorityCell: UITableViewCell!
    
    var selectedPriority: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCellSelection(with: selectedPriority)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let name = Notification.Name(rawValue: priorityNotificationKey)
        NotificationCenter.default.post(name: name, object: selectedPriority)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)!
        selectedPriority = cell.textLabel!.text!
        configureCellSelection(with: selectedPriority)
        
        tableView.reloadData()
    }
    
    func configureCellSelection(with name: String) {
        switch name {
        case "None":
            nonePriorityCell.accessoryType = .checkmark
            lowPriorityCell.accessoryType = .none
            mediumPriorityCell.accessoryType = .none
            highPriorityCell.accessoryType = .none
        case "Low":
            nonePriorityCell.accessoryType = .none
            lowPriorityCell.accessoryType = .checkmark
            mediumPriorityCell.accessoryType = .none
            highPriorityCell.accessoryType = .none
        case "Medium":
            nonePriorityCell.accessoryType = .none
            lowPriorityCell.accessoryType = .none
            mediumPriorityCell.accessoryType = .checkmark
            highPriorityCell.accessoryType = .none
        case "High":
            nonePriorityCell.accessoryType = .none
            lowPriorityCell.accessoryType = .none
            mediumPriorityCell.accessoryType = .none
            highPriorityCell.accessoryType = .checkmark
        default:
            nonePriorityCell.accessoryType = .none
            lowPriorityCell.accessoryType = .none
            mediumPriorityCell.accessoryType = .none
            highPriorityCell.accessoryType = .none
        }
    }
    
//    func configureCellSelection(with row: Int) {
//        switch row {
//        case 0:
//            lowPriorityCell.accessoryType = .none
//            mediumPriorityCell.accessoryType = .none
//            highPriorityCell.accessoryType = .none
//        case 1:
//            nonePriorityCell.accessoryType = .none
//            mediumPriorityCell.accessoryType = .none
//            highPriorityCell.accessoryType = .none
//        case 2:
//            nonePriorityCell.accessoryType = .none
//            lowPriorityCell.accessoryType = .none
//            highPriorityCell.accessoryType = .none
//        case 3:
//            nonePriorityCell.accessoryType = .none
//            lowPriorityCell.accessoryType = .none
//            mediumPriorityCell.accessoryType = .none
//        default:
//            nonePriorityCell.accessoryType = .none
//            lowPriorityCell.accessoryType = .none
//            mediumPriorityCell.accessoryType = .none
//            highPriorityCell.accessoryType = .none
//        }
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
