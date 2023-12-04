import Foundation


// MARK: Define the Task class
public class Task: Event {
    
    // Define static properties
    var id: Int
    var title: String
    var start: Date?
    var size: Size
    var priority: Priority
    var difficulty: Difficulty
    var category: String?
    var notes: String?
    
    // Determine computed property: duration of time for task based on provided size of task
    public var duration: TimeInterval {
        get {
            var taskTime: TimeInterval = 0
            switch size {
            case .small:
                taskTime = 15 * 60
            case .medium:
                taskTime = 30 * 60
            case .large:
                taskTime = 60 * 60
            case .extraLarge:
                taskTime = 90 * 60
            }
            return taskTime
        }
        set {
            let taskTime: TimeInterval = 0
            switch taskTime {
            case 0...900: // 0-15 minutes (0-15 minutes is 0 seconds to 900 seconds)
                size = .small
            case 901...1800: // 16-30 minutes (16-30 minutes is 901 seconds to 1800 seconds)
                size = .medium
            case 1801...3600: // 31-60 minutes (31-60 minutes is 1801 seconds to 3600 seconds)
                size = .large
            case 3601...5400: // 61-90 minutes (61-90 minutes is 3601 seconds to 5400 seconds)
                size = .extraLarge
            default:
                size = .extraLarge
            }
        }
    }

    // Initialize the static properties
    public init(id: Int, title: String, start: Date? = nil, size: Size, priority: Priority, difficulty: Difficulty, category: String? = nil, notes: String? = nil) {
        self.id = id
        self.title = title
        self.start = start
        self.size = size
        self.priority = priority
        self.difficulty = difficulty
        self.category = category
        self.notes = notes
    }
}
