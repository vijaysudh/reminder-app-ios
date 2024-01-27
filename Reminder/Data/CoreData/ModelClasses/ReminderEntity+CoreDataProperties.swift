//  ReminderEntity+CoreDataProperties.swift
//  Reminder
//
//  Created by Vijaysudh M on 1/1/24.
//  
//
//

import Foundation
import CoreData

extension ReminderEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReminderEntity> {
        return NSFetchRequest<ReminderEntity>(entityName: "ReminderEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var reminderId: UUID
    @NSManaged public var reminderListId: UUID
    @NSManaged public var title: String
    @NSManaged public var note: String?
    @NSManaged public var state: String
    @NSManaged public var isAlarmRequired: Bool
    @NSManaged public var remindOnDate: Date?
    @NSManaged public var updatedAt: Date
    @NSManaged public var createdAt: Date
    @NSManaged public var alarmDetail: AlarmDetailEntity?
}

extension ReminderEntity: Identifiable {

}
