//
//  NewGroupViewController.swift
//  TaskManager
//
//  Created by Aiden on 03/12/2021.
//

import UIKit
import CoreData

protocol NewGroupProtocol {
    func didAddNewGroup(with group: Group)
}

class NewGroupViewController: UIViewController {

    @IBOutlet weak var colorStack: UIStackView!
    @IBOutlet weak var groupNameTextField: UITextField!
    
    var context: NSManagedObjectContext!
    var delegate: NewGroupProtocol!
    var selectedColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isModalInPresentation = true
        
        groupNameTextField.delegate = self
        groupNameTextField.font = UIFont(name: K.fonts.sfproRounded_Medium, size: 32)
        groupNameTextField.becomeFirstResponder()
        
        let symbolConfig = UIImage.SymbolConfiguration(scale: .large)
        let imageSetConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
        let colorImageUnchecked = UIImage(systemName: "circle", withConfiguration: symbolConfig)
        let colorImageChecked = UIImage(named: "circle.inset.filled", in: nil, with: imageSetConfig)
        
        for colorButton in colorStack.arrangedSubviews as! [CheckButton] {
            colorButton.setTitle("", for: .normal)
            colorButton.checkedImage = colorImageChecked!
            colorButton.uncheckedImage = colorImageUnchecked!
        }
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func colorPicked(_ sender: CheckButton) {
        for colorButton in colorStack.arrangedSubviews as! [CheckButton] {
            colorButton.isChecked = false

        }
        sender.isChecked = true
        selectedColor = sender.tintColor
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneClicked(_ sender: Any) {
        let groupTitle = groupNameTextField.text!
        if !groupTitle.isEmpty {
            let group = Group(context: context)
            group.name = groupTitle
            group.creationDate = Date()
            group.backgroundColor = UIColor.systemRed as NSObject
            group.backgroundColor = selectedColor as! NSObject
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
            delegate.didAddNewGroup(with: group)
            dismiss(animated: true)
        }
    }
}

extension NewGroupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
