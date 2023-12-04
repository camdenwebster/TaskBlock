import Foundation

// MARK: Global Functions
func log(_ string: String) {
    if debug {
        print("DEBUG: \(string)")
    }
}

func printTasks(tasks: Array<Task>) -> String {
    var tasksList = ""
    var taskString = ""
    for task in tasks {
        taskString = """
                        - Task ID: \(task.id), title: \(task.title), size: \(task.size), duration: \(task.duration / 60) minutes, priority: \(task.priority), difficulty: \(task.difficulty), category: \(task.category ?? "None"), notes: \(task.notes ?? "None")\n
                        """
        tasksList.append(taskString)
    }
    return tasksList
}

func printBlocks(blocks: Array<Block>) -> String {
    var blocksList = ""
    var blockString = ""
    for block in blocks {
        blockString = block.displayBlockInfo()
        blocksList.append(blockString)
    }
    return blocksList
}

func printTime(date: Date) -> String {
    let timeString = date.formatted(date: .omitted, time: .shortened)
    return timeString
}

// MARK: Define the Day class
public class Day: Event  {
    
    // Define static properties
    var id: Int
    var title: String
    var startHour: Int?
    var start: Date? {
        get {
            var components = DateComponents()
            components.hour = startHour
            components.minute = 0
            let startDate = Calendar.current.date(from: components) ?? .now
            return startDate
        }
        set {
            let date = newValue
            let calendar = Calendar.current
            startHour = calendar.component(.hour, from: date ?? .now)
        }
    }
    var duration: TimeInterval
    var inputTasks: Array<Task>
    var inputBlocks: Array<Block>
    
    public init(id: Int, title: String, startHour: Int, start: Date? = nil, duration: TimeInterval, inputTasks: Array<Task>, inputBlocks: Array<Block>) {
        self.id = id
        self.title = title
        self.startHour = startHour
        self.duration = duration
        self.inputTasks = inputTasks
        self.inputBlocks = inputBlocks
    }
    
    func scheduleBlock(tasks: Array<Task>, block: Block) -> Array<Task> {
        // Initialize tasks as a variable
        log("Input tasks for scheduleBlock (Block \(block.id)):\n\(printTasks(tasks: tasks))")
        // 1. Filter for tasks that match the preferred category
        var tasksMatchingCategory = tasks.filter { $0.category == block.preferredCategory }
        // If no tasks were matching the category, just grab all the tasks
        if tasksMatchingCategory.isEmpty {
            tasksMatchingCategory = tasks
        }
        log("Categorized tasks for block ID \(block.id):\n\(printTasks(tasks: tasksMatchingCategory))")
        
        // 2. Sort tasks that by preferred difficulty of the block
        let tasksSortedByDifficulty = sortByDifficulty(tasks: tasksMatchingCategory, preferredDifficulty: block.preferredDifficulty)

        //tasks = tasks.filter { $0.difficulty == block.preferredDifficulty }
        log("Tasks sorted by difficulty for block ID \(block.id):\n\(printTasks(tasks: tasksSortedByDifficulty))")
        
        // 3. Sort the remaining tasks by their priority, from highest to lowest
        let prioritizedTasks = prioritizeTasks(tasks: tasksSortedByDifficulty)
        log("Prioritized tasks for block ID \(block.id):\n\(printTasks(tasks: prioritizedTasks))")

        // 4. Fit as many tasks into the block as we can given the time constraints
        let scheduledTasks = fitTasksIntoBlock(tasks: prioritizedTasks, duration: block.duration)
        log("Added the following tasks to Block \(block.id)\n\(printTasks(tasks: scheduledTasks))")
        return scheduledTasks
    }
    
    func sortByDifficulty(tasks: Array<Task>, preferredDifficulty: Difficulty) -> Array<Task> {
        // Copy the list of tasks into a new array to be filtered for positive category matches
        var tasksMatchingDifficulty = tasks
        // Copy the list of tasks into a new array for the rest of the tasks that don't match
        var tasksNotMatchingDifficulty = tasks
        tasksMatchingDifficulty.removeAll(where: { $0.difficulty != preferredDifficulty })
        tasksNotMatchingDifficulty.removeAll(where: { $0.difficulty == preferredDifficulty })
        // Combine the two array so that the matching tasks are placed at the top
        let sortedTasks = tasksMatchingDifficulty + tasksNotMatchingDifficulty
        return sortedTasks
    }
    
    func prioritizeTasks(tasks: Array<Task>, descending: Bool = true) -> Array<Task> {
        var prioritizedTasks = [Task]()             // Create an empty array to start adding tasks to, in the proper order
        var priorityEnum = Priority.allCases
        if descending {
            // We'll reverse the order of the enum values (in order to sort high to low) unless we want to do ascending
            priorityEnum = priorityEnum.reversed()
        }
        for priority in priorityEnum {
            // For each priority in the Priority enum, add matching tasks to the array
            let tasksOfGivenPriority = tasks.filter({ $0.priority == priority })
            prioritizedTasks += tasksOfGivenPriority
        }
        return prioritizedTasks
    }
    
    func fitTasksIntoBlock(tasks: Array<Task>, duration: TimeInterval) -> Array<Task> {
        var tasksInBlock = [Task]()             // Create a new array for the tasks that will fit in this block
        var timeCounter: TimeInterval = 0       // Define variable for our time counter
        for task in tasks {      // Loop through the array of provided tasks
            let taskTime = task.duration    // Get the duration of the task
            let blockTime = duration * 60      // Get the duration of the block in seconds
            // Check if we've hit the limit of the time block yet. Add the taskTime to the total time before proceeding to make sure we're not going to go over the limit with the next addition
            if (timeCounter + taskTime) <= blockTime {
                timeCounter += taskTime
                tasksInBlock.append(task) // Add the task to the array
            }
        }
        return tasksInBlock
    }
    
    // MARK: Day scheduling logic
    public func buildSchedule() -> Array<Block> {
        // Start with an empty schedule
        var schedule = [Block]()
        // Get the list of tasks provived for the Day
        let tasksToSchedule = self.inputTasks
        print("Tasks Inbox:\n\(printTasks(tasks: tasksToSchedule))")
        // Print the start time for the day
        let date = start ?? .now
        print("Start of day: \(printTime(date: date))")
        // Set start time for first block
        let firstBlock = inputBlocks[0]
        firstBlock.start = date
        var blockStartTime = firstBlock.start ?? .now
        // Initialize end time for block
        var blockEndTime = blockStartTime
        // Start with the scheduleOfBlocks
        let blocks = inputBlocks
        firstBlock.scheduleOfTasks = tasksToSchedule
        var allTasks = firstBlock.scheduleOfTasks ?? []
        // Logging
        log("Tasks to scheudle for first block:")
        log(printTasks(tasks: allTasks))
        // MARK: Start block operations
        // (Set end time, determine schedule of tasks within the block)
        // Initialize tasks for block
        for block in blocks {
            // Set the end time of the block based on the start time + duration (in minutes). Using a variable here as we will change the end time of the block once we've determined how long all the tasks will take.
            blockEndTime = blockStartTime.addingTimeInterval(block.duration * 60)
            print("Block \(block.id) start time: \(printTime(date: blockStartTime))")
            // Figure out which tasks should go into this block. The previous run should have removed tasks that have already been scheduled
            let tasksForBlock = self.scheduleBlock(tasks: allTasks, block: block)
            // Remove these tasks from the main list of tasks
            for task in tasksForBlock {
                log("Removing task ID: \(task.id) from allTasks since it's been scheduled")
                allTasks.removeAll { $0.id == task.id }
            }
            //allTasks.removeAll(where: { $0.difficulty != preferredDifficulty })
            log("Remaining tasks in allTasks:")
            log(printTasks(tasks: allTasks))
            // Once we've figured that out, put the tasks into the block
            block.scheduleOfTasks = tasksForBlock
            // Logging
            log("Tasks to scheudle for block \(block.id):")
            log(printTasks(tasks: tasksForBlock))
            print()
            // MARK: Begin task operations
            // Initialize the start time of the first task to be the same as the start time of the block before entering the loop
            var taskStartTime = blockStartTime
            // Initialize the previous category before entering the loop
            // Get first task
            let firstTaskCategory = tasksForBlock.first?.category ?? "None"
            var previousTaskCategory = firstTaskCategory
            // (Set start and end times, determine if context-switching buffer is needed)
            for task in tasksForBlock {
                // Initialize taskInfo string
                var taskInfo = ""
                // If the current category does not match the last category, we'll add a 5 minute buffer for context-switching
                let taskCategory = task.category ?? "None"
                if previousTaskCategory != taskCategory {
                    let buffer = TimeInterval(5)
                    let bufferString = "--- (added \(buffer) minutes for context switch)\n\n"
                    taskStartTime = taskStartTime.addingTimeInterval(buffer * 60 * -1)
                    taskInfo.append(bufferString)
                }
                // Store the start time for the task
                task.start = taskStartTime
                // Calculate the end time for the task
                let endTime = taskStartTime.addingTimeInterval(task.duration)
                // Set up the task info string
                taskInfo.append("""
                        - Task ID: \(task.id)
                        -- Task start date/time: \(printTime(date: taskStartTime))
                        -- Task title: \(task.title)
                        -- Task size: \(task.size)
                        -- Task duration: \(task.duration / 60) minutes
                        -- Task priority: \(task.priority)
                        -- Task difficulty: \(task.difficulty)
                        -- Task category: \(task.category ?? "None")
                        -- Task end date/time: \(printTime(date: endTime))\n
                        """)
                print(taskInfo)
                // Now that we've printed the info, we can remove that task from the array.
                // MARK: Set things up for the next task
                // Set the start time for the next task to be the same as the end time of the last task before evaluating context switch
                taskStartTime = endTime
                // Set the end time of the block to be the same as the end time for the task (in case this is the final task)
                blockEndTime = endTime
                // Set the previous task category to determine context-switch on the next run
                previousTaskCategory = taskCategory
            }

            // Print end time
            print("Block \(block.id) end time: \(printTime(date: blockEndTime))")
            // Add  15 minute buffer between blocks
            let buffer = TimeInterval(15)
            let bufferString = "--- (added \(buffer) minutes for context switch)\n\n"
            print(bufferString)
            blockEndTime = blockEndTime.addingTimeInterval(buffer * 60)
            blockStartTime = blockEndTime
            schedule.append(block)
        }
        // Add the daily review
        let reviewStartTime = blockEndTime
        let reviewEndTime = reviewStartTime.addingTimeInterval(60 * 60)
        print("Daily review start time: \(printTime(date: reviewStartTime))")
        print("Daily review end time: \(printTime(date: reviewEndTime))")
        // Figure out the buffer of time remaining after all the blocks have been added
        print("Buffer start time: \(printTime(date: reviewEndTime))")
        // Convert duration (hours) into seconds and add it to the start time to get the end time
        let endTime = start?.addingTimeInterval(duration * 60 * 60)
        print("End of day: \(printTime(date: endTime ?? .now))\n")
        return schedule
    }
}
