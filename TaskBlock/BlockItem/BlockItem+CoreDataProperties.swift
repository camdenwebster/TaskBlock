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

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var preferredDifficulty: Int16
    @NSManaged public var preferredCategory: String
    @NSManaged public var start: Date?
    @NSManaged public var end: Date?

}

extension BlockItem : Identifiable {

}
