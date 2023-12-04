import Foundation


// MARK: Define the Block class
public class Block: Event {

    // Define static properties
    var id: Int
    var title: String
    var preferredDifficulty: Difficulty
    var preferredCategory: String?
    var startHour: Int?
    var start: Date?
    var duration: TimeInterval
    var scheduleOfTasks: Array<Task>?
    
    // Initialize the static properties
    public init(id: Int, title: String, preferredDifficulty: Difficulty, preferredCategory: String = "", startHour: Int? = 8, start: Date? = nil, duration: TimeInterval, scheduleOfTasks: Array<Task>? = nil) {
        self.id = id
        self.title = title
        self.preferredDifficulty = preferredDifficulty
        self.preferredCategory = preferredCategory
        self.startHour = startHour
        self.start = start
        self.duration = duration
        self.scheduleOfTasks = scheduleOfTasks
    }
    
    func displayBlockInfo() -> String {
        let string = "Block id: \(self.id), title: \(self.title), difficulty: \(self.preferredDifficulty), category: \(self.preferredCategory ?? "None")\n"
        return string
    }
}
