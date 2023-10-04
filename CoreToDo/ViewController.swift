//
//  ViewController.swift
//  CoreToDo
//
//  Created by Sneezy on 9/23/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var priority = 1
    
    var buttonTitle = "Add Task"
    var editTask: Task!
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var priorityStepper: UIStepper!
    @IBOutlet weak var priorityDescriptionLabel: UILabel!
    @IBOutlet weak var taskButton: UIButton!
    
    @IBAction func addTaskButton(_ sender: UIButton) {
        if buttonTitle == "Edit Task" {
            if let taskName = taskTextField.text {
                if taskName != "" {
                    let task = editTask
                    task!.name = taskName
                    task!.priority = priorityDescriptionLabel.text
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    navigationController!.popViewController(animated: true)
                }
            }
        } else {
            if let taskName = taskTextField.text {
                if taskName != "" {
                    let task = Task(context: context)
                    task.name = taskName
                    task.priority = priorityDescriptionLabel.text
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    navigationController!.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func changePriority(_ sender: UIStepper) {
        priority = Int(priorityStepper.value)
        priorityLabel.text = "Priority Level \(priority)"
        
        if priority == 1 {
            priorityDescriptionLabel.text = "Low"
            priorityDescriptionLabel.textColor = UIColor.systemGreen
        } else if priority == 2 {
            priorityDescriptionLabel.text = "Normal"
            priorityDescriptionLabel.textColor = UIColor.black
        } else if priority == 3 {
            priorityDescriptionLabel.text = "High"
            priorityDescriptionLabel.textColor = UIColor.systemRed
        } else {
            priorityDescriptionLabel.text = "EXTRA HIGH"
            priorityDescriptionLabel.textColor = UIColor.red
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskTextField.delegate = self
        self.taskTextField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.taskTextField.becomeFirstResponder()
        
        taskButton.setTitle(buttonTitle, for: .normal)
        
        if buttonTitle == "Edit Task" {
            taskTextField.text = editTask.name
            priorityDescriptionLabel.text = editTask.priority
            
            if priorityDescriptionLabel.text == "Low" {
                priority = 1
                priorityDescriptionLabel.textColor = UIColor.systemGreen
            } else if priorityDescriptionLabel.text == "Normal" {
                priority = 2
                priorityDescriptionLabel.textColor = UIColor.black
            } else if priorityDescriptionLabel.text == "High" {
                priority = 3
                priorityDescriptionLabel.textColor = UIColor.systemRed
            } else {
                priority = 4
                priorityDescriptionLabel.textColor = UIColor.red
            }
            
            priorityLabel.text = "Priority Level \(priority)"
            priorityStepper.value = Double(priority)
           // priorityLabel.text = "Priority Level \(editTask.p)"
        }
    }
    
    
}

