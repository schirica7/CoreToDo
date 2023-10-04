//
//  ListTableVC.swift
//  CoreToDo
//
//  Created by Sneezy on 9/26/22.
//

import UIKit

class ListTableVC: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    @IBSegueAction func infoSegue(_ coder: NSCoder) -> ViewController? {
//        return <#ViewController(coder: coder)#>
//    }
    
    var tasks: [Task]  = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCoreData()
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    func getCoreData() {
        do {
            tasks = try context.fetch(Task.fetchRequest())
        } catch {
            print("Data not found")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.priority
        
        if (task.priority == "Low") {
            cell.detailTextLabel?.textColor = UIColor.systemGreen
        } else if (task.priority == "Normal") {
            cell.detailTextLabel?.textColor = UIColor.black
        } else if (task.priority == "High") {
            cell.detailTextLabel?.textColor = UIColor.systemRed
        } else {
            cell.detailTextLabel?.textColor = UIColor.red
        }
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let task = tasks[indexPath.row]
            tasks.remove(at: indexPath.row)
            context.delete(task)
            tableView.deleteRows(at: [indexPath], with: .fade)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    

    //These create custom options of what you can do if you swipe from right to left -- new buttons
    //New functions override default
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Trash") {
            [weak self] (action, view, completionHandler)
            in self?.deleteTask(indexPath: indexPath)
            completionHandler(true)
        }
        
        let decreaseAction = UIContextualAction(style: .normal, title: "Priority -") {
            [weak self] (action, view, completionHandler)
            in self?.decreasePriority(indexPath: indexPath)
            completionHandler(true)
        }
        decreaseAction.backgroundColor = .systemOrange
        
        let increaseAction = UIContextualAction(style: .normal, title: "Priority +") {
            [weak self] (action, view, completionHandler)
            in self?.increasePriority(indexPath: indexPath)
            completionHandler(true)
        }
        increaseAction.backgroundColor = .systemGreen
        
        //This actually shows the buttons, and places them in reverse order from how you write them
        return UISwipeActionsConfiguration(actions: [deleteAction, decreaseAction, increaseAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
      
        
        let extraPriority = UIContextualAction(style: .destructive, title: "Extra High Priority") {
            [weak self] (action, view, completionHandler)
            in self?.makePriorityExtraHigh(indexPath: indexPath)
            completionHandler(true)
        }
        
        extraPriority.backgroundColor = .systemBlue
        
        //This now goes from left to right
        return UISwipeActionsConfiguration(actions: [extraPriority])
    }
    
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
    
    func deleteTask(indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        tasks.remove(at: indexPath.row)
        context.delete(task)
        tableView.deleteRows(at: [indexPath], with: .fade)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func decreasePriority(indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        
        switch task.priority {
        case "Low":
            break
        case "Normal":
            task.priority = "Low"
            break
        case "High":
            task.priority = "Normal"
            break
        case "EXTRA HIGH":
            task.priority = "High"
            break
        default :
            break
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        print("Decrease")
    }
    
    func increasePriority(indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        
        switch task.priority {
        case "Low":
            task.priority = "Normal"
            break
        case "Normal":
            task.priority = "High"
            break
        case "High":
            task.priority = "EXTRA HIGH"
            break
        default :
            break
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        print("Increase")
    }
    
    //MARK: DO as a class
    
    func makePriorityExtraHigh(indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        task.priority = "Extra High".uppercased()
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "EditSegue" {
            let viewController = segue.destination as! ViewController
        }
    }*/
    
    //This is edit task
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTask = tasks[indexPath.row]
        
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "ViewController") as? ViewController {
            viewController.buttonTitle = "Edit Task"
            viewController.editTask = selectedTask
            navigationController?.pushViewController(viewController, animated: true)
           // viewController.
        }
    }
     
    
    
}
 
