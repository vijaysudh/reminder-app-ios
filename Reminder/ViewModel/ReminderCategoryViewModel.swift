//  ReminderCategoryViewModel.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/20/23.
//  
//

import Foundation

protocol ReminderCategoryInterface {
    func loadReminderCategoryList() async
}

@Observable class ReminderCategoryViewModel: ReminderCategoryInterface {
    private var reminderCategoryList = [ReminderCategoryList]()
    
    func getAllReminderCategories() -> [ReminderCategoryList] {
        return reminderCategoryList
    }
    
    func loadReminderCategoryList() async {
        // TODO: Temp code to start skeleton of the View
        reminderCategoryList.removeAll()
        var id = UUID(uuidString: "3469243d-5909-4703-a05c-0353ed59e060") ?? UUID()
        let reminderCategory = ReminderCategoryList(id: id, name: "Reminders")
        reminderCategoryList.append(reminderCategory)
    }
}
