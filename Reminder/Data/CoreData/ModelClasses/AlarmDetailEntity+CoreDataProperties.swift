//  AlarmDetailEntity+CoreDataProperties.swift
//  Reminder
//
//  Created by Vijaysudh M on 1/1/24.
//  
//
//

import Foundation
import CoreData

extension AlarmDetailEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmDetailEntity> {
        return NSFetchRequest<AlarmDetailEntity>(entityName: "AlarmDetailEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var reminder: ReminderEntity?
    @NSManaged public var updatedAt: Date
    @NSManaged public var createdAt: Date
}

extension AlarmDetailEntity: Identifiable {

}
