//
//  Block.swift
//  TaskBlock
//
//  Created by Camden Webster on 4/25/24.
//

import Foundation

class Block {
    
    // Define static properties
    var id: Int
    var title: String?
    var preferredDifficulty: Int?
    var preferredCategory: String?
    //    var startHour: Int?
    var start: Date = .now
    var end: Date = .now
    var scheduleOfToDoItems: Array<ToDoItem>?

//    var duration: TimeInterval {
//        return end.timeIntervalSince(start)
//    }
    
    // Initialize the static properties
    init(id: Int, title: String, preferredDifficulty: Int, preferredCategory: String = "", start: Date, end: Date, scheduleOfToDoItems: Array<ToDoItem>? = nil) {
        self.id = id
        self.title = title
        self.preferredDifficulty = preferredDifficulty
        self.preferredCategory = preferredCategory
//        self.startHour = startHour
        self.start = start
        self.scheduleOfToDoItems = scheduleOfToDoItems
    }
    
    func displayBlockInfo() -> String {
        let string = "Block id: \(self.id), title: \(self.title ?? "Block title"), difficulty: \(self.preferredDifficulty ?? 1), category: \(self.preferredCategory ?? "None")\n"
        return string
    }
}

