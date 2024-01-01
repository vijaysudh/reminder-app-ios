//  ReminderListViewModelFactory.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/20/23.
//  
//

import Foundation

protocol BaseReminderViewModelFactory {
    associatedtype ViewModelType: ReminderListViewModel
    var reminderCategoryId: UUID { get set }
    func createModel() -> ViewModelType
}

class ReminderListViewModelFactory: BaseReminderViewModelFactory {
    typealias ViewModelType = ReminderListViewModel
    var reminderCategoryId: UUID
    
    init(reminderCategoryId: UUID) {
        self.reminderCategoryId = reminderCategoryId
    }
    
    func createModel() -> ReminderListViewModel {
       print("ReminderListViewModelFactory: " + ApplicationConfiguration.sharedInstance.getApplicationConfig().environment.rawValue)
        return ReminderListViewModel(reminderCategoryId: reminderCategoryId)
    }
}


