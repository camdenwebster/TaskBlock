//
//  SettingsViewController.swift
//  TabBarPickersDemoCamdenW
//
//  Created by Camden Webster on 2/20/24.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    var blockItems = [BlockItem]()
    var sections = ["General", "Schedule Settings", "About"]
    var settingsItems: [[Setting]] = [
        [
            Setting(identifier: "appearance", title: "Appearance", description: "Apperance settings", symbol: UIImage(systemName: "eye"), type: nil, subSections: ["Theme", "Inbox Placement"]),
            Setting(identifier: "calendarReminderSettings", title: "Calendar and Reminder Settings", description: "Settings for the Apple Calendar and Reminders integration", symbol: UIImage(systemName: "calendar"), type: nil, subSections: ["Calendar", "Reminders"]),
            Setting(identifier: "iCloudSettings", title: "iCloud Settings", description: "View iCloud synchronization settings", symbol: UIImage(systemName: "cloud"), type: nil, subSections: ["iCloud Sync Status"])
        ],
        [
            Setting(identifier: "blockSettings", title: "Blocks", description: "View currently configured blocks", symbol: UIImage(systemName: "calendar.day.timeline.left"), type: nil, subSections: ["Blocks", "Add New"]),
            Setting(identifier: "daySettings", title: "Day Settings", description: "View start and end times for daily schedule", symbol: UIImage(systemName: "calendar"), type: nil, subSections: ["Start and End Time"])
        ],
        [
            Setting(identifier: "about", title: "About", description: "View more information about this app", symbol: UIImage(systemName: "info.circle"), type: nil, subSections: ["Version Details", "Contact"])
        ]
        
         
//         , "Calendar and Reminders Settings", "iCloud Settings"],
//        ["Day Start Time", "Day End Time"],
//        [],
//        ["About", "Contact"]
    ]
    let initialSettings: [String: String] = ["Theme": "matchSystem", "Inbox Placement": "inboxAbove"]

    
    @IBSegueAction func showSettingsDetail(_ coder: NSCoder) -> SettingsDetailViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else { fatalError("Nothing selected!") }
        let item = settingsItems[indexPath.section][indexPath.row]
        return SettingsDetailViewController(coder: coder, item: item)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let initialSettings = initialSettings
        for item in settingsItems {
            item.forEach { item in initializeUserDefaults(dict: initialSettings, key: item.identifier) }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        let rowData = settingsItems[indexPath.section][indexPath.row]
        cell.textLabel?.text = rowData.title
        if let cellImage = rowData.symbol {
            cell.imageView?.image = cellImage
        }
//        cell.textLabel?.text = settingsItems[indexPath.section][indexPath.row].title
//        let symbolName = "star.fill"
//                cell.imageView?.image = UIImage(systemName: symbolName)
                cell.imageView?.tintColor = .systemBlue
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped \(settingsItems[indexPath.section][indexPath.row].title)")
    }
    
    func initializeUserDefaults(dict: [String : Any], key: String) {
        let defaults = UserDefaults.standard

        // Check if the dictionary already has a value
        if defaults.object(forKey: "appearance") == nil {
            // Set initial dictionary values
            let initialSettings: [String: Any] = dict
            defaults.set(initialSettings, forKey: "appearance")
        }
    }

}
