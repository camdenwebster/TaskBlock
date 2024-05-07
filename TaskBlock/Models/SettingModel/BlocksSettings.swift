//
//  BlocksSettings.swift
//  TaskBlock
//
//  Created by Camden Webster on 5/4/24.
//

import Foundation
import UIKit

struct BlocksSettings: SettingsSubMenuConfig {
    var sections: [String]? = ["Blocks", "Add"]
    var settings: [[SettingsSubMenuItem]] = [
        [
        
        ],
        [
            SettingsSubMenuItem(identifier: "addBlock", title: "Add Block", description: "Tap button to add a new block", symbol: nil, type: .button)
        ]
    ]
}
