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
    @IBOutlet var notesLabel: UILabel!
    @IBOutlet var startDateLabel: UILabel!
    @IBOutlet var endDateLabel: UILabel!
            
    @IBAction func didTapCircle(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected == true {
            enableUIElements(false)
        } else {
            enableUIElements(true)
        }
    }
    
    func enableUIElements(_ state: Bool = true) {
        titleField.isEnabled = state
        notesLabel.isEnabled = state
        startDateLabel.isEnabled = state
        endDateLabel.isEnabled = state
    }

//    @IBOutlet var priority: UIImageView!
//    @IBOutlet var difficulty: UIImageView!
}
