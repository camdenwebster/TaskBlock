//
//  DaySettings.swift
//  TaskBlock
//
//  Created by Camden Webster on 5/5/24.
//

import Foundation
import UIKit

struct DaySettings: SettingsSubMenu {
    var settings: [[Setting]] {
        [
            [
                Setting(identifier: "startTime", title: "Start Time", description: "Date picker to determine daily schedule start time", symbol: nil, type: .text),
                Setting(identifier: "endTime", title: "End Time", description: "Date picker to determine daily schedule end time", symbol: nil, type: .text),
            ]
        ]
    }
}
