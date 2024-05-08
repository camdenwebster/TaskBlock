//
//  BlockItem+CoreDataProperties.swift
//  TaskBlock
//
//  Created by Camden Webster on 4/26/24.
//
//

import Foundation
import CoreData


extension BlockItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlockItem> {
        return NSFetchRequest<BlockItem>(entityName: "BlockItem")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String?
    @NSManaged public var preferredDifficulty: Int16
    @NSManaged public var preferredCategory: String
    @NSManaged public var start: Date
    @NSManaged public var end: Date
    
    func addToDoItemsToBlock(_ toDos: [ToDoItem]) -> [ToDoItem] {
        var toDosInBlockTimeRange = [ToDoItem]()
        
        for toDo in toDos {
            if toDo.assignedBlock == nil {
                guard let startTime = toDo.start else {
                    return toDosInBlockTimeRange
                }
                if startTime >= start && startTime <= end {
                    toDosInBlockTimeRange.append(toDo)
                    toDo.assignedBlock = id
                }
            } else {
                return toDosInBlockTimeRange
            }
        }

//        toDos.forEach { $0.assignedBlock = id }
        return toDosInBlockTimeRange
    }
    
    func autoScheduleToDos(_ toDos: [ToDoItem]) -> [ToDoItem] {
        // TODO: Add UI for maually assigning a block, then evaulate it here
        // 1. Evaluate manually assigned blocks
        // Initialize toDos as a variable
        print("Input toDos for scheduleBlock (Block \(id)")
        //21. Filter for toDos that match the preferred category
        var toDosMatchingCategory = toDos.filter { $0.category == preferredCategory }
        // If no toDos were matching the category, just grab all the toDos
        if toDosMatchingCategory.isEmpty {
            toDosMatchingCategory = toDos
        }
        print("Categorized toDos for block ID \(id)")
        
        // 3. Sort toDos that by preferred difficulty of the block
        let toDosSortedByDifficulty = sortByDifficulty(toDos: toDosMatchingCategory, preferredDifficulty: Int(preferredDifficulty))

        //toDos = toDos.filter { $0.difficulty == block.preferredDifficulty }
        print("toDos sorted by difficulty for block ID \(id)")
        
        // 4. Sort the remaining toDos by their priority, from highest to lowest
        let prioritizedtoDos = prioritizeToDos(toDos: toDosSortedByDifficulty)
        print("Prioritized toDos for block ID \(id)")

        // 5. Fit as many toDos into the block as we can given the time constraints
//        let scheduledtoDos = fittoDosIntoBlock(toDos: prioritizedtoDos, duration: block.duration)
//        print("Added the following toDos to Block \(block.id)\n\(printtoDos(toDos: scheduledtoDos))")
        return prioritizedtoDos
    }
    
    private func sortByDifficulty(toDos: [ToDoItem], preferredDifficulty: Int) -> [ToDoItem] {
        // Copy the list of tasks into a new array to be filtered for positive category matches
        var tasksMatchingDifficulty = toDos
        // Copy the list of tasks into a new array for the rest of the tasks that don't match
        var tasksNotMatchingDifficulty = toDos
        tasksMatchingDifficulty.removeAll(where: { $0.difficulty != preferredDifficulty })
        tasksNotMatchingDifficulty.removeAll(where: { $0.difficulty == preferredDifficulty })
        // Combine the two array so that the matching tasks are placed at the top
        let sortedTasks = tasksMatchingDifficulty + tasksNotMatchingDifficulty
        return sortedTasks
    }
    
    func prioritizeToDos(toDos: [ToDoItem]) -> [ToDoItem] {
        let prioritizedToDos = toDos.sorted { $0.priority < $1.priority }
        return prioritizedToDos
    }

}

extension BlockItem : Identifiable {

}
