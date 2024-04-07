//
//  DetailViewController.swift
//  TableViewDemoCamdenW
//
//  Created by Camden Webster on 2/27/24.
//

import UIKit

class DetailViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    // MARK: - Initialize constants
    let viewElements = [
    ["Title", "Notes"],
    ["Start date", "Due Date"],
    ["Size", "Difficulty", "Priority"],
    ["Category"]
    ]
    let todo: ToDo
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
    @IBOutlet weak var categoryButtonMenu: UIButton!
    @IBOutlet weak var notesTextView: UITextView!
    
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = UIApplication.shared.delegate as? UITabBarControllerDelegate
        // Set up text fields
        titleTextField.becomeFirstResponder()
        titleTextField.text = todo.title
        titleTextField.delegate = self
        // Set placeholder for notes view
        notesTextView.text = todo.notes
        placeholderLabel.text = "Notes"
        placeholderLabel.font = UIFont.systemFont(ofSize: (notesTextView.font?.pointSize)!, weight: .regular)
        placeholderLabel.sizeToFit()
        notesTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (notesTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.placeholderText
        placeholderLabel.isHidden = !notesTextView.text.isEmpty
        notesTextView.delegate = self
        // Set up dates
        startDatePicker.date = todo.start ?? .now
        endDatePicker.date = todo.end ?? .now
        // Set up segmented controls
        sizeControl.selectedSegmentIndex = todo.size
        difficultyControl.selectedSegmentIndex = todo.difficulty
        priorityControl.selectedSegmentIndex = todo.priority
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // TODO: pop alert when back/cancel button is pressed, allowing user to discard changes
//        if isMovingFromParent {
//            let alert = UIAlertController(title: "Are you sure?", message: "Changes will be lost", preferredStyle: .alert)
//            
//            let okAction = UIAlertAction(title: "Discard Changes", style: .destructive) { [ weak self ] _ in
//                // Dismiss the current view controller after the user clears the alert
//                self?.navigationController?.popViewController(animated: true)
//            }
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action -> Void in
//                //Just dismiss the action sheet
//            })
//            alert.addAction(okAction)
//            alert.addAction(cancelAction)
//            present(alert, animated: true, completion: nil)
//            // Prevent the parent view controller from being displayed until the user clears the alert
//            navigationController?.topViewController?.navigationItem.backBarButtonItem?.isEnabled = false
//        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let destVC = segue.destination as! TasksViewController
        guard let titleText = titleTextField.text, !titleText.isEmpty else {
            print("No title set, returning")
            return
        }
        // If a value was entered we'll log it and close the sheet
        todo.title = titleText
        print("Setting task id \(todo.id) title to '\(todo.title ?? "")'")
        guard let notesText = notesTextView.text, !notesText.isEmpty else {
            print("No notes set, returning")
            return
        }
        todo.notes = notesText
        print("Setting task id \(todo.id) notes to '\(todo.notes ?? "")'")
    }

    required init?(coder: NSCoder) { fatalError("This should never be called!") }
    
    init?(coder: NSCoder, todo: ToDo) {
      self.todo = todo
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
        }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        titleTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }

    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Are you sure?", message: "Changes will be lost", preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Discard Changes", style: .destructive) { [ weak self ] _ in
            // Dismiss the current view controller after the user clears the alert
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
            todo.size = 0
        case 1:
            todo.size = 1
        case 2:
            todo.size = 2
        default: todo.size = 3
        }
        print("Set task size to \(todo.size)")
    }
    
    @IBAction func startDatePicker(_ sender: UIDatePicker) {
        todo.start = startDatePicker.date
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        print ("Setting start date to \(dateFormatter.string(from: todo.start ?? .now))")
    }
    
    @IBAction func endDatePicker(_ sender: UIDatePicker) {
        todo.end = endDatePicker.date
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        print ("Setting end date to \(dateFormatter.string(from: todo.end ?? .now))")
    }
    
    @IBAction func difficultyControlTapped(_ sender: UISegmentedControl) {
        switch difficultyControl.selectedSegmentIndex {
        case 0:
            todo.difficulty = 0
        case 1:
            todo.difficulty = 1
        case 2:
            todo.difficulty = 2
        default: todo.difficulty = 1
        }
        print("Set task difficulty to \(todo.difficulty)")
    }
    
    @IBAction func priorityControlTapped(_ sender: UISegmentedControl) {
        switch priorityControl.selectedSegmentIndex {
        case 0:
            todo.priority = 0
        case 1:
            todo.priority = 1
        case 2:
            todo.priority = 2
        default: todo.priority = 1
        }
        print("Set task priority to \(todo.priority)")
    }
    
    @IBAction func categoryMenuTapped(_ sender: UIButton) {
        // TODO:
    }
        
    func deleteTodo() {
        // Set up alert to be thrown if back button is tapped

    }
}
