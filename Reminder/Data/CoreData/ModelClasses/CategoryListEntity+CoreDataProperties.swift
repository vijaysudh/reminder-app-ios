//  CategoryListEntity+CoreDataProperties.swift
//  Reminder
//
//  Created by Vijaysudh M on 1/1/24.
//  
//
//

import Foundation
import CoreData

extension CategoryListEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryListEntity> {
        return NSFetchRequest<CategoryListEntity>(entityName: "CategoryListEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var iconName: String
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
}

extension CategoryListEntity: Identifiable {

}
