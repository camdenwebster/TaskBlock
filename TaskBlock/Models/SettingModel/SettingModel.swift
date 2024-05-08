//
//  SettingsItemModel.swift
//  TaskBlock
//
//  Created by Camden Webster on 4/30/24.
//

import Foundation
import UIKit

enum SettingType {
    case checkmark
    case button
    case text
    case date
    case selection(options: [String])
}

protocol SettingsSubMenuConfig {
    var sections: [String]? { get }
    var settings: [[SettingsSubMenuItem]] { get }
}

class SettingItem {
    var identifier: String
    var title: String
    var description: String?
    var type: SettingType?
    var accessory: UITableViewCell.AccessoryType?
    var textColor: UIColor {
        switch type {
        case .button:
            return .systemBlue
        default:
            return .label
        }
    }
    var userInteractionEnabled: Bool {
        switch type {
        case .text:
            return false
        default:
            return true
        }
    }
    
//    init(identifier: String, title: String, description: String? = nil, type: SettingType?, accessory: UITableViewCell.AccessoryType? = nil) {
//        self.identifier = identifier
//        self.title = title
//        self.description = description
//        self.accessory = accessory
//    }
    
    init(identifier: String, title: String, description: String? = nil, type: SettingType? = nil, accessory: UITableViewCell.AccessoryType? = nil) {
        self.identifier = identifier
        self.title = title
        self.description = description
        self.type = type
        self.accessory = accessory
    }
}

class SettingsMainMenuItem: SettingItem {
    let symbol: UIImage?
    var subMenu: SettingsSubMenuConfig
    
    init(identifier: String, title: String, description: String? = nil, type: SettingType?, accessory: UITableViewCell.AccessoryType? = nil, symbol: UIImage?, subMenu: SettingsSubMenuConfig) {
        self.symbol = symbol
        self.subMenu = subMenu
        super.init(identifier: identifier, title: title, type: type, accessory: accessory)
    }
    
//    func getSettingsSubMenuItems(item: SettingsMainMenuItem) -> [[SettingsSubMenuItem]] {
//        switch item.identifier {
//        case "appearance":
//            return AppearaceSettings().settings
//        case "calendarReminderSettings":
//            return CalendarAndReminderSettings().settings
//        case "iCloudSettings":
//            return iCloudSettings().settings
//        case "blockSettings":
//            return BlocksSettings().settings
//        case "daySettings":
//            return DaySettings().settings
//        case "about":
//            return AboutSettings().settings
//        default:
//            return AppearaceSettings().settings
//        }
//    }

}



class SettingsSubMenuItem: SettingItem {
    // The result of interacting with the item - i.e. boolean checkmark, date picker, etc)
    var value: Any?
    
    init(identifier: String, title: String, description: String?, accessory: UITableViewCell.AccessoryType? = nil, symbol: UIImage?, type: SettingType?, value: Any? = nil, subSections: [String]? = nil) {
        self.value = value
        super.init(identifier: identifier, title: title, type: type, accessory: accessory)
    }
}
