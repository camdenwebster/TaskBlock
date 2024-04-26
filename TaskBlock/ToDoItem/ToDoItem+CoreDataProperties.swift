//
//  ToDoItem+CoreDataProperties.swift
//  TaskBlock
//
//  Created by Camden Webster on 4/18/24.
//
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var category: String?
    @NSManaged public var difficulty: Int16
    @NSManaged public var end: Date?
    @NSManaged public var id: String
    @NSManaged public var notes: String?
    @NSManaged public var priority: Int16
    @NSManaged public var size: Int16
    @NSManaged public var start: Date?
    @NSManaged public var title: String?
    @NSManaged public var completed: Bool
    @NSManaged public var completedDate: Date?

}

extension ToDoItem : Identifiable {

}
