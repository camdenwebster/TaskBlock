//
//  SettingsUIComponent.swift
//  TaskBlock
//
//  Created by Camden Webster on 4/30/24.
//

import Foundation
import UIKit

struct SettingsDetailCell {
    var settingToUseForConfig: Setting
    var parentScreen: String
    var selectedItem: String
    var enableUserInteraction: Bool = false
    let vc = SettingsViewController()
    var selectedIndexPaths: [Int: IndexPath] = [:]
    
    func configureTextColor() -> UIColor {
        switch settingToUseForConfig.type {
        case .button:
            return .systemBlue
        default:
            return .label
        }
    }
    
    func configureUserInteraction() -> Bool{
        switch settingToUseForConfig.type {
        case .text:
            return false
        default:
            return true
        }
    }
        
//    func configureAccessory() -> UITableViewCell.AccessoryType {
//        var accessory = UITableViewCell.AccessoryType.none
//        switch settingToUseForConfig.type {
//        case .checkmark:
//            if settingToUseForConfig.identifier == selectedItem {
//                accessory = .checkmark
//            } else {
//                accessory = .none
//            }
//            return accessory
//        default:
//            return accessory
//        }
//    }
    

    

}
    



