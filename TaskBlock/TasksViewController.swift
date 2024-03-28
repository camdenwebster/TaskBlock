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

    var dataManager: NSManagedObjectContext!
    var listArray = [NSManagedObject]()
        
    // Default task to be added at app launch
    var todos = [ToDo]()
    
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow
        else { fatalError("Nothing selected!") }
        let todo = todos[indexPath.row]
        return DetailViewController(coder: coder, todo: todo)    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        // Do any additional setup after loading the view.
        for todo in todos {
            guard todo.title != nil else {
                return
            }
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        cell.textLabel?.text = "\(todos[indexPath.row].title ?? "New Task")"
        return cell
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        var newId: Int
        if let lastId = todos.last?.id {
            newId = lastId + 1
        } else {
            newId = 0
            print("First task - setting it as ID: \(newId)")
        }
        let newToDo = ToDo(id: newId)
        print("Adding task with ID: \(newToDo.id) to todos array")
        todos.append(newToDo)
        self.tableView.reloadData()
    }
    
    @IBAction func unwindToTaskView(_ sender: UIStoryboardSegue) {}

    // MARK: - CoreData operations
    //    func fetchName(id: Int) -> ToDo {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Todo")
//        do {
//            let result = try dataManager.fetch(fetchRequest)
//            listArray = result as! [NSManagedObject]
//            for item in listArray {
//                let product = item.value(forKey: "id") as! Int
//                    toDoName.text! += product
//            }
//            return result
//        } catch {
//            print("Error retrieving data")
//        }
//    }
//    
//    func save(name: String) {
//      
//      guard let appDelegate =
//        UIApplication.shared.delegate as? AppDelegate else {
//        return
//      }
//      
//      // 1
//      let managedContext = appDelegate.persistentContainer.viewContext
//      
//      // 2
//      let entity =  NSEntityDescription.entity(forEntityName: "ToDo", in: managedContext)!
//      
//      let person = NSManagedObject(entity: entity, insertInto: managedContext)
//      
//      // 3
//      person.setValue(name, forKeyPath: "title")
//      
//      // 4
//      do {
//        try managedContext.save()
//        people.append(person)
//      } catch let error as NSError {
//        print("Could not save. \(error), \(error.userInfo)")
//      }
//    }
    
}
