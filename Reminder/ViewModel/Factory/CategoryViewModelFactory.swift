//  CategoryViewModelFactory.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/22/23.
//  
//

import Foundation

protocol BaseCategoryViewModelFactory {
    associatedtype ViewModelType: CategoryViewModel
    func createModel() -> ViewModelType
}

class CategoryViewModelFactory: BaseCategoryViewModelFactory {
    typealias ViewModelType = CategoryViewModel

    func createModel() -> CategoryViewModel {
       print("CategoryViewModelFactory: " + ApplicationConfiguration
        .sharedInstance.getApplicationConfig()
        .environment.rawValue)
        let categoryListRepository = ApplicationConfiguration
            .sharedInstance.getApplicationConfig().categoryListRepository
        return CategoryViewModel(categoryListRepository: categoryListRepository)
    }
}
