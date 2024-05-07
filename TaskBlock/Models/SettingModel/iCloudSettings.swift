//
//  iCloudSettings.swift
//  TaskBlock
//
//  Created by Camden Webster on 5/5/24.
//

import Foundation
import UIKit

struct iCloudSettings: SettingsSubMenuConfig {
    var sections: [String]? = ["iCloud Sync Status"]
    var settings: [[SettingsSubMenuItem]] {
        [
            [
                SettingsSubMenuItem(identifier: "syncStatus", title: "Fully Synced", description: "Current sync status", symbol: nil, type: .text),
                SettingsSubMenuItem(identifier: "syncNowButton", title: "Sync Now", description: "Tap to sync with iCloud", symbol: nil, type: .button)
            ]
        ]
    }
    
    
}
