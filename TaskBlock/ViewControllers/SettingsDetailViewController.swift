//
//  SettingsDetailViewController.swift
//  TaskBlock
//
//  Created by Camden Webster on 4/30/24.
//

import UIKit

class SettingsDetailViewController: UITableViewController {
    weak var delegate: DestinationDelegate?
    var item: Setting
    var sections = [String]()
    var settings = [[Setting]]()
    var selectedIndexPaths: [Int: IndexPath] = [:]
//    let componentFactory = SettingsComponentFactory()
    var selectedItem: String?
    let defaults = UserDefaults.standard
    let settingsVC = SettingsViewController()
    var initiallySelectedItems = [Any?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = item.title
        let settingsConfig = getSettingsSubMenuConfig(item: item)
        settings = settingsConfig.settings
        sections = item.subSections ?? ["Section 1", "Section 2"]
        for section in sections {
            let item = fetchValueForKey(section)
            initiallySelectedItems.append(item)
            
            print("Initially selected item for \(section) is \(item ?? "item")")
        }
        self.clearsSelectionOnViewWillAppear = false
    }
    
    
    required init?(coder: NSCoder) { fatalError("This should never be called!") }
    
    init?(coder: NSCoder, item: Setting) {
        self.item = item
        super.init(coder: coder)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settings[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsDetailCell", for: indexPath)
        let setting = settings[indexPath.section][indexPath.row]
        let cellConfig = SettingsDetailCell(settingToUseForConfig: setting, parentScreen: item.identifier, selectedItem: selectedItem ?? "Selected Item")
        cell.textLabel?.textColor = cellConfig.configureTextColor()
        cell.textLabel?.text = setting.title
        cell.textLabel?.numberOfLines = 3
        
//        if setting.identifier != settingsVC.initialSettings[section] {
//            cell.accessoryType = cellConfig.configureAccessory()
//        } else {
//            cell.accessoryType = .checkmark
//        }
        if setting.identifier == selectedItem {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.isUserInteractionEnabled = cellConfig.configureUserInteraction()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let setting = settings[indexPath.section][indexPath.row]
        
        selectedItem = setting.identifier
        
        print("Tapped \(selectedItem ?? "cellName") cell")
        
        switch setting.type {
        case .checkmark:
            updateCurrentlySelectedItem(tableView, indexPath: indexPath)
            if section == "Theme" {
                let settingsConfig = AppearaceSettings()
                settingsConfig.switchAppearance(setting)
            }
        default:
            print("No action configured")
            
        }
        updateDictionary(key: section, value: setting.identifier)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func getSettingsSubMenuConfig(item: Setting) -> SettingsSubMenu {
        switch item.identifier {
        case "appearance":
            return AppearaceSettings()
        case "calendarReminderSettings":
            return CalendarAndReminderSettings()
        case "iCloudSettings":
            return iCloudSettings()
        case "blockSettings":
            return BlocksSettings()
        case "daySettings":
            return DaySettings()
        case "about":
            return AboutSettings()
        default:
            return AppearaceSettings()
        }
    }
    
    func updateCurrentlySelectedItem(_ tableView: UITableView, indexPath: IndexPath) {
        // Check if the selected index path is already selected
        if let selectedIndexPath = selectedIndexPaths[indexPath.section], selectedIndexPath == indexPath {
            // Deselect the row by removing its selection
            selectedIndexPaths[indexPath.section] = nil
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            // Clear previously selected index path for the same section
            if let previouslySelectedIndexPath = selectedIndexPaths[indexPath.section] {
                selectedIndexPaths[previouslySelectedIndexPath.section] = nil
                tableView.reloadRows(at: [previouslySelectedIndexPath], with: .automatic)
            }
            // Update selected index path for the current section
            selectedIndexPaths[indexPath.section] = indexPath
            tableView.reloadRows(at: [indexPath], with: .automatic)
  
        }
    }
    
//    func saveDictionary(key: String, value: String, forDict settingsSubMenu: String) {
//        let defaults = UserDefaults.standard
//        let userSettings: [String: String] = [key: value]
//
//        defaults.set(userSettings, forKey: item.identifier)
//    }
    
    func fetchValueForKey(_ dictionaryKey: String) -> Any? {
        let defaults = UserDefaults.standard

        // Retrieve the dictionary from UserDefaults
        if let settingsDictionary = defaults.dictionary(forKey: item.identifier) {
            // Retrieve the string value using the dictionary key
            if let value = settingsDictionary[dictionaryKey] as? String {
                return value
            } else {
                print("The value for key '\(dictionaryKey)' is not a String or does not exist.")
            }
        } else {
            print("No dictionary found for key '\(item.identifier)'.")
        }

        return nil
    }
    
    func updateDictionary(key: String, value: String) {
        let defaults = UserDefaults.standard

        if var userSettings = defaults.dictionary(forKey: item.identifier) as? [String: String] {
            userSettings[key] = value
            defaults.set(userSettings, forKey: item.identifier)
            print("Set \(value) value for key \(key)")
        }
    }

    
}
