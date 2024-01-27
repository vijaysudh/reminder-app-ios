//  CategoryViewModel.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/20/23.
//  
//

import Foundation

protocol CategoryInterface {
    // Create
    func add(categoryList: CategoryList) async throws
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
    private var categoryListRepository: any CategoryListRepositoryInterface

    init(categoryListRepository: any CategoryListRepositoryInterface) {
        self.categoryListRepository = categoryListRepository
    }

    func add(categoryList: CategoryList) async throws {
        do {
            categoryLists.append(categoryList)
            try await categoryListRepository.add(categoryList)
        } catch let error {
            throw error
        }
    }

    func loadCategoryList() async {
        do {
            guard let fetchedCategoryLists = try await categoryListRepository.list() as? [CategoryList] else {
                return
            }
            categoryLists.removeAll()
            for categoryList in fetchedCategoryLists {
                categoryLists.append(categoryList)
            }
        } catch let error {
            print("Error loading category: " + error.localizedDescription)
            // TODO: Will need to add a UI for Error state
        }
    }

    func getAllCategories() -> [CategoryList] {
        return categoryLists
    }

    func updateCategory(forId id: UUID, withUpdate update: CategoryList) {
        guard let index = categoryLists.firstIndex(where: { $0.id == id }) else {
            return
        }
        categoryLists[index] = update
        Task {
            do {
                try await categoryListRepository.update(id, withUpdate: update)
            } catch let error {
                print("Error updating category: " + error.localizedDescription)
                // TODO: Will need to add a UI for Error state
            }
        }
    }

    func deleteCategory(id: UUID) {
        guard let index = categoryLists.firstIndex(where: { $0.id == id }) else {
            return
        }
        categoryLists.remove(at: index)
        Task {
            do {
                try await categoryListRepository.delete(id)
            } catch let error {
                print("Error deleting category: " + error.localizedDescription)
                // TODO: Will need to add a UI for Error state
            }
        }
    }
}
