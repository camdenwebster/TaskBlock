//
//  ScheduleViewController.swift
//  TaskBlock
//
//  Created by Camden Webster on 4/22/24.
//

import UIKit

class ScheduleViewController: UIViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var toDoItems = [ToDoItem]()
    private var blockItems = [BlockItem]()
    let toDoVC = InboxViewController()
    @IBOutlet var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        for todo in toDoItems {
            guard todo.title != nil else {
                return
            }
            print("Loading item \(todo.title ?? "New task") into Schedule view")

        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for toDo in toDoItems {
            toDoVC.printTaskDetails(toDo)
        }
        // Calling this at viewWillAppear instead of viewDidLoad because viewDidLoad will not get called when switching between tabs
        self.getScheduledItems()
    }
    
    
    @IBAction func scheduleButtonTapped(_ sender: UIBarButtonItem) {
        print("Schedule button tapped")
    }
    
    @objc
    func toggleWasSelected(sender: UIButton) {
        let rowIndex: Int = sender.tag
        let toDo = toDoItems[rowIndex]
        toDo.completed.toggle()
        print("Set task id: \(toDo.id) to completed: \(toDo.completed)")
        self.updateItems()
//        tableView.reloadData()
    }
    
    
    // MARK: - CoreData actions
    func getScheduledItems() {
        do {
            // Only get toDoItems which have a start date
            toDoItems = try context.fetch(ToDoItem.fetchRequest()).filter { $0.start != nil }
            // Then sort them by their start date
            toDoItems.sort { (toDoItem1, toDoItem2) -> Bool in
                switch (toDoItem1.start, toDoItem2.start) {
                case (let date1?, let date2?):
                    return date1 < date2  // Both dates are non-nil, compare them directly.
                case (nil, _):
                    return false          // nil is considered later than any date.
                case (_, nil):
                    return true           // Any date is considered earlier than nil.
                }
            }

            print("Fetched ToDos from CoreData:")
            for toDoItem in toDoItems {
                toDoVC.printTaskDetails(toDoItem)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            fatalError("Failed to get items")
        }
    }
    
    func updateItems() {
        if context.hasChanges {
            do {
                try context.save()
                print("Saved CoreData items")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        } else {
            print("No changes detected")
        }
    }
    

}
// MARK: - TableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Header"
    }
    
    
}

// MARK: - TableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ToDoCell.self)", for: indexPath) as? ToDoCell else { fatalError("Could not create ToDo cell") }
        let toDo = toDoItems[indexPath.row]

        if toDo.completed {
            cell.completionToggle.isSelected = true
            cell.enableUIElements(false)
        } else {
            cell.completionToggle.isSelected = false
            cell.enableUIElements(true)
        }
        
        cell.completionToggle.setTitle("", for: .normal)
        cell.completionToggle.tag = indexPath.row
        cell.completionToggle.addTarget(self, action: #selector(toggleWasSelected(sender:)), for: .touchUpInside)

        if let notes = toDo.notes {
            cell.notesLabel.isHidden = false
            cell.notesLabel.text = notes
        } else {
            cell.notesLabel.isHidden = true
        }
        
        if let startDate = toDo.start {
            cell.startDateLabel.isHidden = false
            let startDateText = toDoVC.convertDateToString(startDate)
            cell.startDateLabel.text = "Start: \(startDateText)"
        } else {
            cell.startDateLabel.isHidden = true
        }
        
        if let endDate = toDo.end {
            cell.endDateLabel.isHidden = false
            let endDateText = toDoVC.convertDateToString(endDate)
            cell.endDateLabel.text = "End: \(endDateText)"
        } else {
            cell.endDateLabel.isHidden = true
        }
        
        cell.titleField.text = "\(toDo.title ?? "New Task")"
        
        return cell
    }
    
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        var sections = [String]()
    //
    //        for block in blockItems {
    //            sections.append(block.title ?? "Block Title")
    //        }
    //
    //        return sections[section]
    //    }
    
    // MARK: - Table view data source
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return blockItems.count
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let todo = toDoItems[indexPath.row]
        if editingStyle == .delete {
            print("Removed task id: \(todo.id), title: \(todo.title ?? "") todos array count: \(toDoItems.count)")
            toDoItems.remove(at: indexPath.row)
            self.toDoVC.deleteItem(item: todo)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

