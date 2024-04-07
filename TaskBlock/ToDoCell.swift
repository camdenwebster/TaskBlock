//
//  TaskCell.swift
//  TaskBlock
//
//  Created by Camden Webster on 4/2/24.
//

import UIKit

class ToDoCell: UITableViewCell {
    @IBOutlet var completionToggle: UIImageView!
    @IBOutlet var titleField: UITextView!
    @IBOutlet var category: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!
    @IBOutlet var priority: UIImageView!
    @IBOutlet var difficulty: UIImageView!
}