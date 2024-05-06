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
    private var schedule = [[ToDoItem]]()
    let toDoVC = InboxViewController()
    
    @IBOutlet var tableView: UITableView!
    
    @IBSegueAction func showDetailView(_ coder: NSCoder) -> DetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("Nothing selected!") }
        let toDo = toDoItems[indexPath.row]
        return DetailViewController(coder: coder, toDo: toDo)
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Adding blocks for testing purposes
        do {
            let block1 = BlockItem(context: context)
            block1.id = UUID()
            block1.title = "Block 1"
            block1.preferredCategory = "School"
            block1.preferredDifficulty = 2
            block1.start = setTimeWithTodaysDate(hour: 8)
            block1.end = setTimeWithTodaysDate(hour: 10)
//            blockItems.append(block1)
            
            let block2 = BlockItem(context: context)
            block2.id = UUID()
            block2.title = "Block 2"
            block2.preferredCategory = "Work"
            block2.preferredDifficulty = 1
            block2.start = setTimeWithTodaysDate(hour: 10)
            block2.end = setTimeWithTodaysDate(hour: 12)
//            blockItems.append(block2)
            
            let block3 = BlockItem(context: context)
            block3.id = UUID()
            block3.title = "Block 3"
            block3.preferredCategory = "Work"
            block3.preferredDifficulty = 1
            block3.start = setTimeWithTodaysDate(hour: 13)
            block3.end = setTimeWithTodaysDate(hour: 16)
//            blockItems.append(block3)
            
            
            try context.save()
            
            print("Found \(blockItems.count) blocks")

        }
        catch {
            fatalError("Failed to save blocks")
        }
        
        for todo in toDoItems {
            // Check for title
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
        self.getBlocks()
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
    func getBlocks() {
        do {
            blockItems = try context.fetch(BlockItem.fetchRequest())
            blockItems.sort { (block1, block2) -> Bool in
                switch (block1.title, block2.title) {
                case (let title1?, let title2?):
                    return title1 < title2
                case (nil, _):
                    return false
                case (_, nil):
                    return true
                }
            }
            print("Fetched Blocks from CoreData:")
            for block in blockItems {
                print("Block ID: \(block.id), Block title: \(block.title ?? "New block")")
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            fatalError("Failed to get Blocks from CoreData")
        }
    }
    
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
            
            for block in blockItems {
                schedule.append(block.addToDoItemsToBlock(toDoItems))
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            fatalError("Failed to get ToDos from CoreData")
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
    
    func setTimeWithTodaysDate(hour: Int) -> Date {
        let currentDate = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        components.hour = hour
        components.minute = 0
        components.timeZone = TimeZone.current
        
        return calendar.date(from: components)!
    }
}


// MARK: - TableViewDelegate
extension ScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return blockItems[section].title
    }
}

// MARK: - TableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schedule[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return blockItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ToDoCell.self)", for: indexPath) as? ToDoCell else { fatalError("Could not create ToDo cell") }
        let toDo = schedule[indexPath.section][indexPath.row]

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




