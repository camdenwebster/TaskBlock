//
//  SettingsViewController.swift
//  TabBarPickersDemoCamdenW
//
//  Created by Camden Webster on 2/20/24.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    var blocks = [String]()
    var sections = ["General", "Day Settings", "Block Settings", "Feedback"]
    var settingsItems = [
        ["Calendar and Reminders Settings", "iCloud Settings"],
        ["Day Start Time", "Day End Time"],
        []
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        cell.textLabel?.text = "Settings item 1"
        return cell
    }

}
