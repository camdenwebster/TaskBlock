//
//  TasksViewController.swift
//  TabBarPickersDemoCamdenW
//
//  Created by Camden Webster on 2/20/24.
//

import UIKit
import Foundation
import CoreData

class ToDoListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var toDoItems = [ToDoItem]()
    private var blockItems = [BlockItem]()

//    var listArray = [NSManagedObject]()
    let dateFormatter: DateFormatter = DateFormatter()
    
    
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("Nothing selected!") }
        let todo = toDoItems[indexPath.row]
        return DetailViewController(coder: coder, todo: todo)    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.getAllItems()
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        // Do any additional setup after loading the view.
        for todo in toDoItems {
            guard todo.title != nil else {
                return
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        for toDo in toDoItems {
//            printTaskDetails(toDo)
//        }
        
//        self.updateItems()

        self.getAllItems()
        
//        for toDo in toDoItems {
//            printTaskDetails(toDo)
//        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return blockItems.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ToDoCell.self)", for: indexPath) as? ToDoCell else { fatalError("Could not create ToDo cell") }
        let toDo = toDoItems[indexPath.row]        

        if toDo.completed {
            cell.completionToggle.isSelected = true
        } else {
            cell.completionToggle.isSelected = false
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
            let startDateText = convertDateToString(startDate)
            cell.startDateLabel.text = "Start: \(startDateText)"
        } else {
            cell.startDateLabel.isHidden = true
        }
        
        if let endDate = toDo.end {
            cell.endDateLabel.isHidden = false
            let endDateText = convertDateToString(endDate)
            cell.endDateLabel.text = "End: \(endDateText)"
        } else {
            cell.endDateLabel.isHidden = true
        }
        
        cell.titleField.text = "\(toDo.title ?? "New Task")"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let todo = toDoItems[indexPath.row]
        if editingStyle == .delete {
            toDoItems.remove(at: indexPath.row)
            print("Removed task id: \(todo.id), title: \(todo.title ?? "") todos array count: \(toDoItems.count)")
            self.deleteItem(item: todo)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sections = [String]()
        
        for block in blockItems {
            sections.append(block.title ?? "Block Title")
        }
        
        return sections[section]
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let indexPath = IndexPath(row: toDoItems.count, section: 0)
        let newItem = self.createItem()
        self.getAllItems()
        print("New task - setting it as ID: \(newItem.id)")
        print("todos count: \(toDoItems.count)")
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    
    @IBAction func scheduleButtonTapped(_ sender: UIBarButtonItem) {
        print("Schedule button tapped")
    }
    
    @IBAction func unwindToTaskView(_ sender: UIStoryboardSegue) {}
    
    @objc
    func toggleWasSelected(sender: UIButton) {
        let rowIndex: Int = sender.tag
        let toDo = toDoItems[rowIndex]
        toDo.completed.toggle()
        print("Set task id: \(toDo.id) to completed: \(toDo.completed)")
        self.updateItems()
        tableView.reloadData()
    }
    
    // MARK: CoreData CRUD Actions
    func getAllItems() {
        do {
            toDoItems = try context.fetch(ToDoItem.fetchRequest())
            print("Fetched ToDos from CoreData:")
            for toDoItem in toDoItems {
                printTaskDetails(toDoItem)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            fatalError("Failed to get items")
        }
    }
    
    func discardChanges() {
        context.rollback()
    }
    
    func createItem() -> ToDoItem {
        let newItem = ToDoItem(context: context)
        newItem.title = "New Task"
        newItem.id = UUID()
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
                print("Saved CoreData items")
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func printTaskDetails(_ toDo: ToDoItem) {
        print("Task ID: \(toDo.id), title: \(toDo.title ?? "no title found"), start: \(convertDateToString(toDo.start ?? .now)), end: \(convertDateToString(toDo.end ?? .now)), notes: \(toDo.notes ?? "no notes found")")
    }
    
    func convertDateToString(_ date: Date) -> String {
        // Set the text value
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
