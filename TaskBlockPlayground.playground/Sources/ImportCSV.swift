import Foundation


public func importCSV(filename: String)  ->  Array<Task> {
    var taskArray = [Task]()
    if let fileURL = Bundle.main.url(forResource: filename, withExtension: "csv") {
        do {
            let csvString = try String(contentsOf: fileURL, encoding: .utf8)
            let rows = csvString.components(separatedBy: "\n")
            let rowsWithoutHeader = rows.dropFirst()
            var rowNum = 1
            for row in rowsWithoutHeader {
                let columns = row.components(separatedBy: ",")
                let id = Int(columns[0]) ?? 0
                let title = columns[1]
                let sizeString = columns[2].lowercased()
                let priorityString = columns[3].lowercased()
                let difficultyString = columns[4].lowercased()
                let category = columns[5]
                let notes = columns[6]
                
                if debug {
                    let rowText = "Row \(rowNum), id: \(id), title: \(title), size: \(sizeString), priority = \(priorityString), difficulty: \(difficultyString), category: \(category), notes: \(notes)"
                    log(rowText)
                    rowNum += 1
                }
                
                // Initialize variables
                var size: Size
                var priority: Priority
                var difficulty: Difficulty
                
                // Determine size
                switch sizeString {
                case "small":
                    size = .small
                case "large":
                    size = .large
                case "extraLarge":
                    size = .extraLarge
                default:
                    size = .medium
                }
                
                // Determine priority
                switch priorityString {
                case "low":
                    priority = .low
                case "high":
                    priority = .high
                default:
                    priority = .medium
                }
                
                // Determine difficulty
                switch difficultyString {
                case "low":
                    difficulty = .low
                case "high":
                    difficulty = .high
                default:
                    difficulty = .medium
                }
                
                // Assemble Task
                let taskFromRow = Task(id: id, title: title, size: size, priority: priority, difficulty: difficulty, category: category, notes: notes)
                taskArray.append(taskFromRow)
            }
        } catch {
            print("Error reading the CSV file: \(error.localizedDescription)")
        }
    } else {
        print("CSV file not found")
    }
    return taskArray
}
