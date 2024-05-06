//
//  iCloudSettings.swift
//  TaskBlock
//
//  Created by Camden Webster on 5/5/24.
//

import Foundation
import UIKit

struct iCloudSettings: SettingsSubMenu {
    var settings: [[Setting]] {
        [
            [
                Setting(identifier: "syncStatus", title: "Fully Synced", description: "Current sync status", symbol: nil, type: .text),
                Setting(identifier: "syncNowButton", title: "Sync Now", description: "Tap to sync with iCloud", symbol: nil, type: .button)
            ]
        ]
    }
    
    
}
