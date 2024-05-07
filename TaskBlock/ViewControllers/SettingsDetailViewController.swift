//
//  SettingsDetailViewController.swift
//  TaskBlock
//
//  Created by Camden Webster on 4/30/24.
//

import UIKit

class SettingsDetailViewController: UITableViewController {
    
    weak var delegate: DestinationDelegate?
    var item: SettingsMainMenuItem
    var sections = [String]()
    var settings = [[SettingsSubMenuItem]]()
    var selectedIndexPaths: [Int: IndexPath] = [:]
//    var selectedOptions: [Int:Int] = [:]
    var dictFromDefaults = [String:Any]()
//    {
//        didSet {
//            // Save the new selections to UserDefaults
//            UserDefaults.standard.set(selectedOptions, forKey: item.identifier)
//            // Update the table view
//            tableView.reloadData()
//        }
//    }
    
    let settingsVC = SettingsViewController()
    var initiallySelectedItems = [Any?]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = item.title
        settings = item.subMenu.settings
        sections = item.subMenu.sections ?? ["Section 1", "Section 2"]
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsDetailCell")
        // Load the initial selections from UserDefaults
        if let userDefaultsDict = fetchDictFromDefaults(item.identifier) {
            print("Loaded user defaults \(userDefaultsDict) at viewDidLoad")
//            selectedIndexPaths =
            dictFromDefaults = userDefaultsDict
        } else {
            print("Could not load user defaaults at viewDidLoad")
        }
    }
    
    
    required init?(coder: NSCoder) { fatalError("This should never be called!") }
    
    init?(coder: NSCoder, item: SettingsMainMenuItem) {
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
        

        cell.textLabel?.textColor = setting.textColor
        cell.textLabel?.text = setting.title
        cell.textLabel?.numberOfLines = 3
        
        if let selectedIndexPath = selectedIndexPaths[indexPath.section], selectedIndexPath == indexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.isUserInteractionEnabled = setting.userInteractionEnabled
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
                
        // Update the selected option for the section
//        selectedOptions[indexPath.section] = indexPath.row
        let section = sections[indexPath.section]
        let setting = settings[indexPath.section][indexPath.row]
        
//        selectedIndexPaths[indexPath.section] = indexPath
                
        switch setting.type {
        case .checkmark:
            updateCurrentlySelectedItem(indexPath: indexPath)
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
    
    
    func updateCurrentlySelectedItem(indexPath: IndexPath) {
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
    
    func addNewKeyValuePair(key: String, value: String, toDictionary dictionaryKey: String) {
        let defaults = UserDefaults.standard
        
        // Retrieve the existing dictionary or create a new one if it doesn't exist
        var dictionary = defaults.dictionary(forKey: dictionaryKey) ?? [String: Any]()
        
        // Add the new key/value pair
        dictionary[key] = value
        
        // Save the updated dictionary back to UserDefaults
        defaults.set(dictionary, forKey: dictionaryKey)
    }

    
    func fetchDictFromDefaults(_ dictionary: String) -> [String:Any]? {
        let defaults = UserDefaults.standard

        // Retrieve the dictionary from UserDefaults
        if let settingsDictionary = defaults.dictionary(forKey: item.identifier) {
            // Retrieve the string value using the dictionary key
            return settingsDictionary
        } else {
            print("No dictionary found for key '\(item.identifier)'.")
            return nil
        }
    }
    
    func fetchValueForKey(_ dictionaryKey: String) -> Any? {
        let defaults = UserDefaults.standard

        // Retrieve the dictionary from UserDefaults
        if let settingsDictionary = defaults.dictionary(forKey: item.identifier) {
            // Retrieve the string value using the dictionary key
            if let value = settingsDictionary[dictionaryKey] as? String {
                print("Read value \(value) for key \(dictionaryKey) from defaults")
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
        let dictionaryKey = item.identifier
        if var userSettings = defaults.dictionary(forKey: dictionaryKey) as? [String: String] {
            userSettings[key] = value
            defaults.set(userSettings, forKey: item.identifier)
            print("Set \(value) value for key \(key)")
        } else {
            addNewKeyValuePair(key: key, value: value, toDictionary: dictionaryKey)
        }
    }

    
}
