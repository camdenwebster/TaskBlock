//
//  CategoriesTableViewController.swift
//  TaskBlock
//
//  Created by Camden Webster on 4/18/24.
//

import UIKit

protocol DestinationDelegate: AnyObject {
    func updateCategory(with text: String)
}

class CategoriesTableViewController: UITableViewController {
    weak var delegate: DestinationDelegate?
    var categories = [String]()
    let defaults = UserDefaults.standard
    var selectedCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = defaults.array(forKey: "categories") as? [String] ?? [String]()
        addCategory("None", atStart: true)
        delegate?.updateCategory(with: selectedCategory ?? "None")
        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateCategory(with: selectedCategory ?? "None")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        if categories[indexPath.row] == selectedCategory {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let key = "categories"
        if editingStyle == .delete {
            // Delete the row from the data source
            categories.remove(at: indexPath.row)
            defaults.set(categories, forKey: key)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for row in 0..<tableView.numberOfRows(inSection: 0) {
                let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0))
                cell?.accessoryType = .none
            }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            selectedCategory = categories[indexPath.row]
            cell.accessoryType = .checkmark
            print("Selected category is now \(selectedCategory ?? "None")")
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Category", message: "Enter a new category below", preferredStyle: .alert)

        alert.addTextField { textField in
                textField.placeholder = "School, Work, etc."
            }
        
        let createAction = UIAlertAction(title: "Create", style: .default) { action in
            if let inputText = alert.textFields?.first?.text {
                self.appendStringToUserDefaultsArray(value: inputText, forArrayKey: "categories")
                self.tableView.reloadData()
                print("User input: \(inputText)")
                // Handle the text from the text field here
            }
        }
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action -> Void in
        })
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func appendStringToUserDefaultsArray(value: String, forArrayKey key: String) {
        // Retrieve the existing array or initialize a new one if it does not exist
        categories = []
        categories = defaults.array(forKey: key) as? [String] ?? [String]()
        
        // Append the new value
        categories.append(value)
        
        // Save the updated array back to UserDefaults
        defaults.set(categories, forKey: key)
    }
    
    func addCategory(_ newCategory: String, atStart: Bool = false) {
        var position = 0
        if !atStart {
            position = categories.count + 1
        }
        if !categories.contains(newCategory) {
            categories.insert(newCategory, at: position)
            defaults.set(categories, forKey: "categories")
        }
    }
}
