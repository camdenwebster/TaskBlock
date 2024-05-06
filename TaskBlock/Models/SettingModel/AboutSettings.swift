//
//  AboutSettings.swift
//  TaskBlock
//
//  Created by Camden Webster on 5/5/24.
//

import Foundation
import UIKit

struct AboutSettings: SettingsSubMenu {
    var settings: [[Setting]] {
        [
            [
                Setting(identifier: "currentVersion", title: "1.0", description: "Version number", symbol: nil, type: .text)
            ],
            [
                Setting(identifier: "contactButton", title: "Contact", description: "Tap here to reach out!", symbol: nil, type: .button),
                Setting(identifier: "reportBugButton", title: "Repot a Bug", description: "Tap here to report a bug", symbol: nil, type: .button),
            ]
        ]
    }
}
