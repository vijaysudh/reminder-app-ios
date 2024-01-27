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
    var categoryName: String { get }
    func createModel() -> ViewModelType
}

class ReminderListViewModelFactory: BaseReminderViewModelFactory {
    typealias ViewModelType = ReminderListViewModel
    var reminderCategoryId: UUID
    var categoryName: String

    init(reminderCategoryId: UUID, categoryName: String) {
        self.reminderCategoryId = reminderCategoryId
        self.categoryName = categoryName
    }

    func createModel() -> ReminderListViewModel {
        print("ReminderListViewModelFactory: " +
              ApplicationConfiguration.sharedInstance.getApplicationConfig().environment.rawValue)
        let reminderRepository = ApplicationConfiguration.sharedInstance
            .getApplicationConfig().reminderRepository
        return ReminderListViewModel(reminderCategoryId: reminderCategoryId,
                                     categoryName: categoryName,
                                     reminderRepository: reminderRepository)
    }
}
