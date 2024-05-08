//
//  MainSettingsMenu.swift
//  TaskBlock
//
//  Created by Camden Webster on 5/5/24.
//

import Foundation
import UIKit

struct MainSettingsMenu {
    // Main Menu Items
    var mainMenuItems: [[SettingsMainMenuItem]] = [
        [
            SettingsMainMenuItem(identifier: "appearance", title: "Appearance", description: "Apperance settings", type: nil, symbol: UIImage(systemName: "eye"), subMenu: AppearaceSettings()),
            SettingsMainMenuItem(identifier: "calendarReminderSettings", title: "Calendar and Reminder Settings", description: "Settings for the Apple Calendar and Reminders integration", type: nil, symbol: UIImage(systemName: "calendar"), subMenu: CalendarAndReminderSettings()),
            SettingsMainMenuItem(identifier: "iCloudSettings", title: "iCloud Settings", description: "View iCloud synchronization settings", type: nil, symbol: UIImage(systemName: "cloud"), subMenu: iCloudSettings())
        ],
        [
            SettingsMainMenuItem(identifier: "blockSettings", title: "Blocks", description: "View currently configured blocks", type: nil, symbol: UIImage(systemName: "calendar.day.timeline.left"), subMenu: BlocksSettings()),
            SettingsMainMenuItem(identifier: "daySettings", title: "Day Settings", description: "View start and end times for daily schedule", type: nil, symbol: UIImage(systemName: "calendar"), subMenu: DaySettings())
        ],
        [
            SettingsMainMenuItem(identifier: "about", title: "About", description: "View more information about this app", type: .text, symbol: UIImage(systemName: "info.circle"), subMenu: AboutSettings())
        ]
    ]
}
        

