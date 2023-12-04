import Foundation

// MARK: - Example calls for production use
//let inbox = importCSV(filename: "tasksData")
//
//let block1 = Block(id: 1, title: "Block 1", preferredDifficulty: .high, preferredCategory: "Work", duration: 90)
//let block2 = Block(id: 2, title: "Block 2", preferredDifficulty: .high, preferredCategory: "School", duration: 90)
//let block3 = Block(id: 3, title: "Block 3", preferredDifficulty: .low, duration: 90)
//
//let blockSchedule: [Block] = [
//    block1,
//    block2,
//    block3
//]
//
//// MARK: - Define properties for the day
//let today = Day(id: 1, title: "Today", startHour: 8, duration: 8, inputTasks: inbox, inputBlocks: blockSchedule)
//today.buildSchedule()

// MARK: - Set up support for testing
struct TestData {
    var testId: Int
    var csv: String
    var preferredDifficulty: [Int: Difficulty]
    var preferredCategory: [Int: String]
    var blockCount: Int = 1
}


func buildDay() -> (TestData)  -> [Block] {
    return {
        var testSchedule = [Block]()
        let id = $0.testId
        print("Running Test ID: \(id)")
        let inbox = importCSV(filename: $0.csv)
        var blockId = 1
        let count = 1...$0.blockCount
        for block in count {
            let difficulty = $0.preferredDifficulty[blockId] ?? .medium
            let category = $0.preferredCategory[blockId] ?? "None"
            let block = Block(id: blockId, title: "Block \(blockId)", preferredDifficulty: difficulty, preferredCategory: category, duration: 90)
            testSchedule.append(block)
            blockId += 1
        }
        let day = Day(id: 1, title: "Test ID \(id)", startHour: 8, duration: 8, inputTasks: inbox, inputBlocks: testSchedule)
        return day.buildSchedule()
    }
}

let day = buildDay()

// MARK: - Test 1
let test1 = TestData(testId: 1, csv: "testID_1", preferredDifficulty: [1: .high], preferredCategory: [1: "Home"])
day(test1)

// MARK: - Test 2
let test2 = TestData(testId: 2, csv: "testID_2", preferredDifficulty: [1: .medium], preferredCategory: [1: "Work"])
day(test2)

// MARK: - Test 3
let test3 = TestData(testId: 3, csv: "testID_3", preferredDifficulty: [1: .medium], preferredCategory: [1: "School"])
day(test3)

// MARK: - Test 4
let test4 = TestData(testId: 4, csv: "testID_4", preferredDifficulty: [1: .medium, 2: .low], preferredCategory: [1: "School", 2: "Work"], blockCount: 2)
day(test4)
