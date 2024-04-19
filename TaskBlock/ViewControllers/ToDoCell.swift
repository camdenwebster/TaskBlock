//
//  TaskCell.swift
//  TaskBlock
//
//  Created by Camden Webster on 4/2/24.
//

import UIKit

class ToDoCell: UITableViewCell {
    
    @IBOutlet var completionToggle: UIButton!
    @IBOutlet var titleField: UILabel!
    @IBOutlet var notes: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!
        
    var toggleFilled: Bool = false
    
    @IBAction func didTapCircle(_ sender: UIButton) {
        sender.isSelected.toggle()
    }

//    @IBOutlet var priority: UIImageView!
//    @IBOutlet var difficulty: UIImageView!
}
