//
//  AppearaceSettings.swift
//  TaskBlock
//
//  Created by Camden Webster on 5/1/24.
//

import Foundation
import UIKit

struct AppearaceSettings: SettingsSubMenuConfig {
    var sections: [String]? = ["Theme", "Inbox Placement"]
    var settings: [[SettingsSubMenuItem]] = [
        [
            SettingsSubMenuItem(identifier: "matchSystem", title: "Match System", description: "Sets display theme to match system setting", symbol: nil, type: .checkmark),
            SettingsSubMenuItem(identifier: "light", title: "Light", description: "Sets display theme to Light Mode", symbol: nil, type: .checkmark),
            SettingsSubMenuItem(identifier: "dark", title: "Dark", description: "Sets display theme to Dark Mode", symbol: nil, type: .checkmark)
        ],
        [
            SettingsSubMenuItem(identifier: "inboxAbove", title: "Above Schedule", description: "Places the inbox above the schedule", symbol: nil, type: .checkmark),
            SettingsSubMenuItem(identifier: "inboxBelow", title: "Below Schedule", description: "Places the inbox Below the schedule", symbol: nil, type: .checkmark)
        ]
     ]
    
    func switchAppearance(_ setting: SettingsSubMenuItem) {
        var mode: UIUserInterfaceStyle
        
        switch setting.identifier {
        case "light":
            mode = .light
        case "dark":
            mode = .dark
        default:
            mode = .unspecified
        }
        
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = mode
            
        }
    }
    

    
}


