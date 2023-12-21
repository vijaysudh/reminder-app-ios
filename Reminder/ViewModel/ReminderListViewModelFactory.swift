//  ReminderListViewModelFactory.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/20/23.
//  
//

import Foundation

protocol BaseReminderViewModelFactory {
    associatedtype ViewModelType: ReminderListViewModel
    func createModel() -> ViewModelType
}

class ReminderListViewModelFactory: BaseReminderViewModelFactory {
    typealias ViewModelType = ReminderListViewModel
    
    func createModel() -> ReminderListViewModel {
        return ReminderListViewModel()
    }
}
