//
//  DetailViewController.swift
//  TableViewDemoCamdenW
//
//  Created by Camden Webster on 2/27/24.
//

import UIKit

class DetailViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, DestinationDelegate {
    
    func updateCategory(with text: String) {
        categorySelectionLabel.text = text
        toDo.category = text
    }
    
    
    // MARK: - Initialize constants
    let viewElements = [
    ["Title", "Notes"],
    ["Start date", "Due Date"],
    ["Size", "Difficulty", "Priority"],
    ["Category"]
    ]
    let toDo: ToDoItem
    let dateFormatter: DateFormatter = DateFormatter()
    let placeholderLabel = UILabel()
    
    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var sizeControl: UISegmentedControl!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var difficultyControl: UISegmentedControl!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var priorityControl: UISegmentedControl!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categorySelectionLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        // Set up text fields
        titleTextField.becomeFirstResponder()
        titleTextField.text = toDo.title
        titleTextField.delegate = self
        
        // Set placeholder for notes view
        notesTextView.text = toDo.notes
        placeholderLabel.text = "Notes"
        placeholderLabel.font = UIFont.systemFont(ofSize: (notesTextView.font?.pointSize)!, weight: .regular)
        placeholderLabel.sizeToFit()
        notesTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (notesTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.placeholderText
        placeholderLabel.isHidden = !notesTextView.text.isEmpty
        notesTextView.delegate = self
        
        // Set up dates
        startDatePicker.date = toDo.start ?? .now
        endDatePicker.date = toDo.end ?? .now
        
        // Set up segmented controls
        sizeControl.selectedSegmentIndex = Int(toDo.size)
        difficultyControl.selectedSegmentIndex = Int(toDo.difficulty)
        priorityControl.selectedSegmentIndex = Int(toDo.priority)
        
        // Set up default category label
        categorySelectionLabel.text = toDo.category ?? "None"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CategoriesView" {
            // Get the destination view controller from the segue
            guard let destinationViewController = segue.destination as? CategoriesTableViewController else {
                return
            }
            // Set a property on the destination view
            destinationViewController.delegate = self
            destinationViewController.selectedCategory = categorySelectionLabel.text
        } else {
            return
        }
    }

    required init?(coder: NSCoder) { fatalError("This should never be called!") }
    
    init?(coder: NSCoder, todo: ToDoItem) {
        self.toDo = todo
        super.init(coder: coder)
    }

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return viewElements.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewElements[section].count
    }
    
    
    // MARK: - Delegate methods
    // UITextViewDelegate method to handle text changes for Notes text view
    // Source: https://stackoverflow.com/a/28271069
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        if let notesText = notesTextView.text {
            toDo.notes = notesText
            print("Setting task id \(toDo.id) notes to '\(toDo.notes ?? "")'")
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty

    }
    
    func textFieldDidChange(_ textField: UITextField) {
        if let titleText = titleTextField.text {
            toDo.title = titleText
            print("Setting task id \(toDo.id) title to '\(toDo.title ?? "")'")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }

    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Are you sure?", message: "Changes will be lost", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Discard Changes", style: .destructive) { [ weak self ] _ in
            // Dismiss the current view controller after the user clears the alert
            let vc = ToDoListViewController()
            vc.discardChanges()
            self?.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action -> Void in
            //Just dismiss the action sheet
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sizeControlTapped(_ sender: UISegmentedControl) {
        switch sizeControl.selectedSegmentIndex {
        case 0:
            toDo.size = 0
        case 1:
            toDo.size = 1
        case 2:
            toDo.size = 2
        default: toDo.size = 3
        }
        print("Set task size to \(toDo.size)")
    }
    
    @IBAction func startDatePicker(_ sender: UIDatePicker) {
        // Compare the dates
        if endDatePicker.date < startDatePicker.date {
            endDatePicker.date = startDatePicker.date
            toDo.end = endDatePicker.date
        }
        toDo.start = startDatePicker.date
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        print ("Setting end date to \(dateFormatter.string(from: toDo.end ?? .now)), start date: \(dateFormatter.string(from: toDo.start ?? .now))")
    }
    
    @IBAction func endDatePicker(_ sender: UIDatePicker) {
        // Compare the dates
        if endDatePicker.date < startDatePicker.date {
            startDatePicker.date = endDatePicker.date
            toDo.start = startDatePicker.date
        }
        toDo.end = endDatePicker.date
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        print ("Setting end date to \(dateFormatter.string(from: toDo.end ?? .now)), start date: \(dateFormatter.string(from: toDo.start ?? .now))")

        
    }
    
    @IBAction func difficultyControlTapped(_ sender: UISegmentedControl) {
        switch difficultyControl.selectedSegmentIndex {
        case 0:
            toDo.difficulty = 0
        case 1:
            toDo.difficulty = 1
        case 2:
            toDo.difficulty = 2
        default: toDo.difficulty = 1
        }
        print("Set task difficulty to \(toDo.difficulty)")
    }
    
    @IBAction func priorityControlTapped(_ sender: UISegmentedControl) {
        switch priorityControl.selectedSegmentIndex {
        case 0:
            toDo.priority = 0
        case 1:
            toDo.priority = 1
        case 2:
            toDo.priority = 2
        default: toDo.priority = 1
        }
        print("Set task priority to \(toDo.priority)")
    }
    
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        let vc = ToDoListViewController()
        vc.updateItems()
        performSegue(withIdentifier: "unwindToTaskView", sender: self)
    }
    
    func deleteTodo() {
        // Set up alert to be thrown if back button is tapped

    }
    
    func dateAlert(message: String) {

    }
}
