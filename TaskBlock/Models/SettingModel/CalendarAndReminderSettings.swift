//
//  CalendarAndReminderSettings.swift
//  TaskBlock
//
//  Created by Camden Webster on 5/2/24.
//

import Foundation
import UIKit

struct CalendarAndReminderSettings: SettingsSubMenuConfig {
    var sections: [String]? = ["Calendar", "Reminders"]
    var settings: [[SettingsSubMenuItem]] = [
        [
            SettingsSubMenuItem(identifier: "calendarInfo", title: "Events from your selected calendars can automatically be displayed on your shchedule.", description: "Events from your selected calendars can automatically be displayed on your shchedule.", symbol: UIImage(systemName: "calendar"), type: .text),
            SettingsSubMenuItem(identifier: "allowCalendarAccessButton", title: "Allow Access", description: "Tap button to select which calendars will be made available to TaskBlock", symbol: nil, type: .button)
        ],
        [
            SettingsSubMenuItem(identifier: "remindersInfo", title: "Enable access to Apple Reminders to allow new Reminders to be added to your Inbox automatically.", description: "Enable access to Apple Reminders to allow new Reminders to be added to your Inbox automatically.", symbol: UIImage(systemName: "calendar"), type: .text),
            SettingsSubMenuItem(identifier: "allowReminderAccessButton", title: "Allow Access", description: "Tap button to enable access to allow new Reminders to be added to your Inbox automatically", symbol: nil, type: .button)
        ]
    ]    
}
