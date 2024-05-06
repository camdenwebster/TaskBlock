//
//  CalendarAndReminderSettings.swift
//  TaskBlock
//
//  Created by Camden Webster on 5/2/24.
//

import Foundation
import UIKit

struct CalendarAndReminderSettings: SettingsSubMenu {
    var settings: [[Setting]] = [
        [
            Setting(identifier: "calendarInfo", title: "Events from your selected calendars can automatically be displayed on your shchedule.", description: "Events from your selected calendars can automatically be displayed on your shchedule.", symbol: UIImage(systemName: "calendar"), type: .text),
            Setting(identifier: "allowCalendarAccessButton", title: "Allow Access", description: "Tap button to select which calendars will be made available to TaskBlock", symbol: nil, type: .button)
        ],
        [
            Setting(identifier: "remindersInfo", title: "Enable access to Apple Reminders to allow new Reminders to be added to your Inbox automatically.", description: "Enable access to Apple Reminders to allow new Reminders to be added to your Inbox automatically.", symbol: UIImage(systemName: "calendar"), type: .text),
            Setting(identifier: "allowReminderAccessButton", title: "Allow Access", description: "Tap button to enable access to allow new Reminders to be added to your Inbox automatically", symbol: nil, type: .button)
        ]
    ]    
}
