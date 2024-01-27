//  CoreDataCategoryListManager.swift
//  Reminder
//
//  Created by Vijaysudh M on 1/1/24.
//  
//

import Foundation
import CoreData

class CoreDataCategoryListManager: CategoryListRepositoryInterface {
    typealias T = CategoryList
    let context = PersistenceController.shared.container.viewContext

    func list() async throws -> [CategoryList] {
        let fetchRequest = NSFetchRequest<CategoryListEntity>(entityName: "CategoryListEntity")
        do {
            var categoryLists = [CategoryList]()
            let categoryListEntities = try context.fetch(fetchRequest)
            for categoryListEntity in categoryListEntities {
                let categoryList = convertCategoryListEntity(categoryListEntity)
                categoryLists.append(categoryList)
            }
            return categoryLists
        } catch let error {
            throw error
        }
    }

    func get(_ id: UUID) async throws -> CategoryList? {
        let fetchRequest = NSFetchRequest<CategoryListEntity>(entityName: "CategoryListEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        do {
            let results = try context.fetch(fetchRequest)
            if let categoryList = results.first {
                return convertCategoryListEntity(categoryList)
            } else {
                return nil
            }
        } catch let error {
            throw error
        }
    }

    func add(_ categoryList: CategoryList) async throws {
        guard let entity = NSEntityDescription.entity(forEntityName: "CategoryListEntity", in: context) else {
            return
        }
        let newCategoryList = NSManagedObject(entity: entity, insertInto: context)
        newCategoryList.setValue(categoryList.id, forKey: "id")
        newCategoryList.setValue(categoryList.name, forKey: "name")
        newCategoryList.setValue(categoryList.iconName, forKey: "iconName")
        newCategoryList.setValue(categoryList.createdAt, forKey: "createdAt")
        newCategoryList.setValue(categoryList.updatedAt, forKey: "updatedAt")
        do {
            try context.save()
        } catch let error {
            throw error
        }
    }

    func delete(_ id: UUID) async throws {
        let fetchRequest = NSFetchRequest<CategoryListEntity>(entityName: "CategoryListEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        do {
            let results = try context.fetch(fetchRequest)
            guard let categoryToDelete = results.first else {
                print("Category with id \(id) not found.")
                return
            }
            context.delete(categoryToDelete)
            try context.save()
        } catch let error {
            throw error
        }
    }

    func update(_ id: UUID, withUpdate categoryList: CategoryList) async throws {
        let fetchRequest = NSFetchRequest<CategoryListEntity>(entityName: "CategoryListEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)

        do {
            let results = try context.fetch(fetchRequest)
            guard let categoryToUpdate = results.first else {
                print("Category with id \(id) not found.")
                return
            }
            categoryToUpdate.id = categoryList.id
            categoryToUpdate.name = categoryList.name
            categoryToUpdate.iconName = categoryList.iconName
            categoryToUpdate.createdAt = categoryList.createdAt
            categoryToUpdate.updatedAt = categoryList.updatedAt
            try context.save()
        } catch let error {
            throw error
        }
    }
}

private extension CoreDataCategoryListManager {
    func convertCategoryListEntity(_ categoryListEntity: CategoryListEntity) -> CategoryList {
        let categoryList = CategoryList(id: categoryListEntity.id,
                                        iconName: categoryListEntity.iconName,
                                        name: categoryListEntity.name,
                                        createdAt: categoryListEntity.createdAt,
                                        updatedAt: categoryListEntity.updatedAt)
        return categoryList
    }
}
