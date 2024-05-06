//
//  SettingsItemModel.swift
//  TaskBlock
//
//  Created by Camden Webster on 4/30/24.
//

import Foundation
import UIKit

protocol SettingsSubMenu {
    var settings: [[Setting]] { get }
}

enum SettingType {
    case checkmark
    case button
    case text
    case date
    case selection(options: [String])
}

struct Setting {
    let identifier: String
    let title: String
    let description: String?
    let symbol: UIImage?
    let type: SettingType?
    var value: Any?
    var subSections: [String]?
}
