//
//  TasksViewController.swift
//  TabBarPickersDemoCamdenW
//
//  Created by Camden Webster on 2/20/24.
//

import UIKit
import Foundation
import CoreData

class TasksViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [ToDoItem]()

//    var listArray = [NSManagedObject]()
    let dateFormatter: DateFormatter = DateFormatter()
    
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow
        else { fatalError("Nothing selected!") }
        let todo = models[indexPath.row]
        return DetailViewController(coder: coder, todo: todo)    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllItems()
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        // Do any additional setup after loading the view.
        for todo in models {
            guard todo.title != nil else {
                return
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateItems()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set up cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ToDoCell.self)", for: indexPath) as? ToDoCell
        else { fatalError("Could not create ToDo cell") }
        let toDo = models[indexPath.row]
        
        // Display notes in cell if a value is found
        if let notes = toDo.notes {
            // Un-hide the label
            cell.notes.isHidden = false
            // Set the text value
            cell.notes.text = notes
        } else {
            // If the string property is nil, hide the label
            cell.notes.isHidden = true
        }
        
        // Display start date in cell if value is found
        if let startDate = toDo.start {
            // Un-hide the label
            cell.startDate.isHidden = false
            // Set the text value
            dateFormatter.timeStyle = .short
            let startDateText = "Start: \(dateFormatter.string(from: startDate))"
            cell.startDate.text = startDateText
        } else {
            // If the string property is nil, hide the label
            cell.notes.isHidden = true
        }
        
        // Display end date in cell if a value is found
        if let endDate = toDo.end {
            // Un-hide the label
            cell.endDate.isHidden = false
            // Set the text value
            dateFormatter.timeStyle = .short
            let endDateText = "End: \(dateFormatter.string(from: endDate))"
            cell.endDate.text = endDateText
        } else {
            // If the string property is nil, hide the label
            cell.notes.isHidden = true
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        cell.titleField.text = "\(toDo.title ?? "New Task")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let todo = models[indexPath.row]
        if editingStyle == .delete {
            models.remove(at: indexPath.row)
            print("Removed task id: \(todo.id), title: \(todo.title ?? "") todos array count: \(models.count)")
            self.deleteItem(item: todo)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let indexPath = IndexPath(row: models.count, section: 0)
        let newItem = self.createItem()
        self.getAllItems()
        print("New task - setting it as ID: \(newItem.id)")
        print("todos count: \(models.count)")
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func unwindToTaskView(_ sender: UIStoryboardSegue) {}
    
    func getAllItems() {
        do {
            models = try context.fetch(ToDoItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            fatalError("Failed to get items")
        }
    }
    
    func createItem() -> ToDoItem {
        let newItem = ToDoItem(context: context)
        newItem.title = "New Task"
        newItem.id = UUID().uuidString
        newItem.priority = 1
        newItem.difficulty = 1
        newItem.size = 1
        newItem.completed = false
        
        do {
            try context.save()
        }
        catch {
            fatalError("Failed to save item id: \(newItem.id), title: \(newItem.title ?? "")")
        }
        return newItem
    }
    
    func deleteItem(item: ToDoItem) {
        context.delete(item)
        
        do {
            try context.save()
        }
        catch {
            fatalError("Failed to delete item id: \(item.id), title: \(item.title ?? "")")
        }
    }
    
    func updateItems() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
