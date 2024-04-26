//
//  ScheduleViewController.swift
//  TaskBlock
//
//  Created by Camden Webster on 4/22/24.
//

import UIKit

class ScheduleViewController: UIViewController {
    private var inboxView: ToDoListViewController!
    @IBOutlet var scheduleListView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        addInboxView()
    }
    
//    private func addInboxView() {
//        inboxView = InboxViewController()
//        addChild(inboxView)
//        inboxView.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
////        scheduleListView.addSubview(inboxView.view)
//        inboxView.didMove(toParent: self)
//    }
}

