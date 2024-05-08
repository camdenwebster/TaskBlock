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
    var selectedIndexes: [Int: IndexPath] = [:] {
            didSet {
                saveSelections()
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = item.title
        settings = item.subMenu.settings
        sections = item.subMenu.sections ?? ["Section 1", "Section 2"]
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsDetailCell")
        // Load the initial selections from UserDefaults
        loadSelections()
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
        
        if let selectedIndexPath = selectedIndexes[indexPath.section], selectedIndexPath == indexPath {
            cell.accessoryType = setting.accessory ?? .none
        } else {
            cell.accessoryType = .none
        }

        cell.isUserInteractionEnabled = setting.userInteractionEnabled
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = settings[indexPath.section][indexPath.row]
        let section = sections[indexPath.section]
        
        switch setting.type {
        case .checkmark:
            selectedIndexes[indexPath.section] = indexPath
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            if section == "Theme" {
                let settingsConfig = AppearaceSettings()
                settingsConfig.switchAppearance(setting)
            }
        default:
            print("No action configured")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    private func saveSelections() {
        let defaults = UserDefaults.standard
        var indexPathDictionary: [String: Any] = [:]
        for (section, indexPath) in selectedIndexes {
            indexPathDictionary["\(section)"] = [indexPath.section, indexPath.row]
        }
        defaults.set(indexPathDictionary, forKey: item.identifier)
        print("Set \(indexPathDictionary) to \(item.identifier) key")
    }

    private func loadSelections() {
        let defaults = UserDefaults.standard
        if let storedIndexPaths = defaults.dictionary(forKey: item.identifier) as? [String: [Int]] {
            for (sectionKey, indexPathArray) in storedIndexPaths {
                if indexPathArray.count == 2 {
                    let indexPath = IndexPath(row: indexPathArray[1], section: indexPathArray[0])
                    selectedIndexes[Int(sectionKey)!] = indexPath
                }
            }
        }
        
        // Set default values if nothing is stored
        if selectedIndexes.isEmpty {
            selectedIndexes[0] = IndexPath(row: 0, section: 0)
            selectedIndexes[1] = IndexPath(row: 0, section: 1)
        }
        
        print("loaded \(selectedIndexes) from \(item.identifier) from userDefaults")
    }
}
