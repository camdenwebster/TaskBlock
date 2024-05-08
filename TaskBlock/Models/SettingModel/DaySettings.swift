//
//  DaySettings.swift
//  ToDoItemBlock
//
//  Created by Camden Webster on 4/25/24.
//

import Foundation

struct DaySettings: SettingsSubMenuConfig {
    var sections: [String]? = ["Start and End Time"]
    var settings: [[SettingsSubMenuItem]] {
        [
            [
                SettingsSubMenuItem(identifier: "startTime", title: "Start Time", description: "Date picker to determine daily schedule start time", symbol: nil, type: .text),
                SettingsSubMenuItem(identifier: "endTime", title: "End Time", description: "Date picker to determine daily schedule end time", symbol: nil, type: .text),
            ]
        ]
    }
}

