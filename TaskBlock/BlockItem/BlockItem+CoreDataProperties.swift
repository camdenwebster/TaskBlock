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
//        var manuallyAssignedToDos = [ToDoItem]()
        // We only want to evaluate the assigned block property if it's been set
//        for toDo in toDos {
//            if toDo.assignedBlock != nil && toDo.assignedBlock == id {
//                manuallyAssignedToDos.append(todo)
//            } else {
//                manuallyAssignedToDos = toDos
//            }
//        }
//        let manuallyAssignedToDos = toDos.filter { $0.assignedBlock != nil && $0.assignedBlock == id }
        let toDosMatchingPreferredCategory = toDos.filter { $0.category == preferredCategory }
        let toDosInBlockTimeRange = toDosMatchingPreferredCategory.filter { $0.start ?? .now >= start && $0.start ?? .now <= end }
        return toDosInBlockTimeRange
    }

}

extension BlockItem : Identifiable {

}
