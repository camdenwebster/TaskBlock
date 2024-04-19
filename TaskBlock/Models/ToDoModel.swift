//
//  ToDoModel.swift
//  TabBarPickersDemoCamdenW
//
//  Created by Camden Webster on 2/21/24.
//

import Foundation


// MARK: Define the ToDo class
class ToDo: Event {
    
    // Define static properties
    var id: Int
    var title: String?
    var completed: Bool
    var completedDate: Date?
    var start: Date?
    var end: Date?
    var size: Int
    var priority: Int
    var difficulty: Int
    var category: String?
    var notes: String?
    
    // Determine computed property: duration of time for task based on provided size of task
    var duration: TimeInterval {
        get {
            var taskTime: TimeInterval = 0
            switch size {
            case 0:
                taskTime = 15 * 60
            case 1:
                taskTime = 30 * 60
            case 2:
                taskTime = 60 * 60
            default:
                taskTime = 30 * 60
            }
            return taskTime
        }
        set {
            let taskTime: TimeInterval = 0
            switch taskTime {
            case 0...900: // 0-15 minutes (0-15 minutes is 0 seconds to 900 seconds)
                size = 0
            case 901...1800: // 16-30 minutes (16-30 minutes is 901 seconds to 1800 seconds)
                size = 1
            case 1801...3600: // 31-60 minutes (31-60 minutes is 1801 seconds to 3600 seconds)
                size = 2
            default:
                size = 1
            }
        }
    }

    // Initialize the static properties
    init(id: Int, title: String? = nil, completed: Bool = false, completedDate: Date? = nil, start: Date? = nil, end: Date? = nil, size: Int = 1, priority: Int = 1, difficulty: Int = 1, category: String? = nil, notes: String? = nil) {
        self.id = id
        self.title = title
        self.completed = completed
        self.completedDate = completedDate
        self.start = start
        self.size = size
        self.priority = priority
        self.difficulty = difficulty
        self.category = category
        self.notes = notes
    }
}
