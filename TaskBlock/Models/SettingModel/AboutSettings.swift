//
//  DaySettings.swift
//  TaskBlock
//
//  Created by Camden Webster on 5/5/24.
//

import Foundation
import UIKit

struct AboutSettings: SettingsSubMenuConfig {
    var sections: [String]? = ["Version Details", "Contact"]
    var settings: [[SettingsSubMenuItem]] {
        [
            [
                SettingsSubMenuItem(identifier: "currentVersion", title: "1.0", description: "Version number", symbol: nil, type: .text)
            ],
            [
                SettingsSubMenuItem(identifier: "contactButton", title: "Contact", description: "Tap here to reach out!", symbol: nil, type: .button),
                SettingsSubMenuItem(identifier: "reportBugButton", title: "Repot a Bug", description: "Tap here to report a bug", symbol: nil, type: .button),
            ]
        ]
    }
    
    
    
    var iCloudSettings: [[SettingsSubMenuItem]] {
        [
            [
                SettingsSubMenuItem(identifier: "syncStatus", title: "Fully Synced", description: "Current sync status", symbol: nil, type: .text),
                SettingsSubMenuItem(identifier: "syncNowButton", title: "Sync Now", description: "Tap to sync with iCloud", symbol: nil, type: .button)
            ]
        ]
    }
    
    
}
