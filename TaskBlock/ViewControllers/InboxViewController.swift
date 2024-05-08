//
//  InboxViewController.swift
//  TaskBlock
//
//  Created by Camden Webster on 2/20/24.
//

import UIKit
import Foundation
import CoreData

class InboxViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var toDoItems = [ToDoItem]()
    let dateFormatter: DateFormatter = DateFormatter()
    
    @IBSegueAction func showDetails(_ coder: NSCoder) -> DetailViewController? {
        let indexPath = IndexPath(row: toDoItems.count, section: 0)
        let newItem = self.createItem()
        print("New task - setting it as ID: \(newItem.id)")
        print("todos count: \(toDoItems.count)")
        return DetailViewController(coder: coder, toDo: newItem)
    }
    
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("Nothing selected!") }
        let toDo = toDoItems[indexPath.row]
        return DetailViewController(coder: coder, toDo: toDo)
    }
    
    
    
    @IBOutlet var notesLabel: UILabel!
    
    // MARK: - View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        for todo in toDoItems {
            guard todo.title != nil else {
                return
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Calling this at viewWillAppear instead of viewDidLoad because viewDidLoad will not get called when switching between tabs
        self.getInboxItems()
    }
    
    
    // MARK: - TableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoItemCell", for: indexPath)
        let toDo = toDoItems[indexPath.row]
        
        if let notes = toDo.notes {
            cell.detailTextLabel?.isHidden = false
            cell.detailTextLabel?.text = notes
        }
        cell.textLabel?.text = toDo.title ?? ""
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
    
    
    // MARK: - Actions
//    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
//        let indexPath = IndexPath(row: toDoItems.count, section: 0)
//        let newItem = self.createItem()
////        self.getAllItems()
//        print("New task - setting it as ID: \(newItem.id)")
//        print("todos count: \(toDoItems.count)")
//        tableView.insertRows(at: [indexPath], with: .automatic)
//    }
    
    
    // MARK: CoreData CRUD Actions
    func getInboxItems() {
        
        do {
            let uncompletedItems = try context.fetch(ToDoItem.fetchRequest()).filter { $0.completed == false }
            toDoItems = uncompletedItems.filter { $0.start == nil }
            print("Fetched Inbox items from CoreData:")
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
        getInboxItems()
    }
    
    func createItem() -> ToDoItem {
        let newItem = ToDoItem(context: context)
        newItem.title = ""
        newItem.id = UUID()
        newItem.priority = 1
        newItem.difficulty = 1
        newItem.size = 1
        newItem.completed = false
        
        do {
            try context.save()
            toDoItems.append(newItem)
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
        } else {
            print("No changes detected")
        }
    }
    
    func printTaskDetails(_ toDo: ToDoItem) {
        if !toDoItems.isEmpty {
            print("Task ID: \(toDo.id), title: \(toDo.title ?? "no title found"), start: \(convertDateToString(toDo.start ?? .now)), end: \(convertDateToString(toDo.end ?? .now)), notes: \(toDo.notes ?? "no notes found"), block: \(toDo.assignedBlock ?? toDo.id)")
        }
    }
    
    func convertDateToString(_ date: Date) -> String {
        // Set the text value
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
