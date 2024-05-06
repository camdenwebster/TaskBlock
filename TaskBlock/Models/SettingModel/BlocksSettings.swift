//
//  BlocksSettings.swift
//  TaskBlock
//
//  Created by Camden Webster on 5/4/24.
//

import Foundation
import UIKit

struct BlocksSettings: SettingsSubMenu {
    var settings: [[Setting]] = [
        [
        
        ],
        [
            Setting(identifier: "addBlock", title: "Add Block", description: "Tap button to add a new block", symbol: nil, type: .button)
        ]
    ]
}
