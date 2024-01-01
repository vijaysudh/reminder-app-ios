//  CategoryViewModel.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/20/23.
//  
//

import Foundation

protocol CategoryInterface {
    // Create
    func add(categoryList: CategoryList)
    // Read
    func loadCategoryList() async
    func getAllCategories() -> [CategoryList]
    // Update
    func updateCategory(forId id: UUID, withUpdate update: CategoryList)
    // Delete
    func deleteCategory(id: UUID)
}

@Observable class CategoryViewModel: CategoryInterface {
    private var categoryLists = [CategoryList]()
    
    func add(categoryList: CategoryList) {
        categoryLists.append(categoryList)
    }
        
    func loadCategoryList() async {
        // TODO: Temp code to start skeleton of the View
//        categoryLists.removeAll()
//        var id = UUID(uuidString: "3469243d-5909-4703-a05c-0353ed59e060") ?? UUID()
//        let reminderCategory = CategoryList(id: id, name: "Reminders")
//        categoryLists.append(reminderCategory)
    }
    
    func getAllCategories() -> [CategoryList] {
        return categoryLists
    }
    
    func updateCategory(forId id: UUID, withUpdate update: CategoryList) {
        guard let index = categoryLists.firstIndex(where: { $0.id == id }) else {
            return
        }
        categoryLists[index] = update
    }
    
    func deleteCategory(id: UUID) {
        guard let index = categoryLists.firstIndex(where: { $0.id == id }) else {
            return
        }
        categoryLists.remove(at: index)
    }
}
