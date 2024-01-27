//  CoreDataReminderManager.swift
//  Reminder
//
//  Created by Vijaysudh M on 1/1/24.
//  
//

import Foundation
import CoreData

class CoreDataReminderManager: ReminderRepositoryInterface {
    typealias T = Reminder
    let context = PersistenceController.shared.container.viewContext
    private var alarmDetailManager: any AlarmDetailRepositoryInterface

    init(alarmDetailManager: any AlarmDetailRepositoryInterface) {
        self.alarmDetailManager = alarmDetailManager
    }

    func list(forReminderId reminderId: UUID) async throws -> [Reminder] {
        let fetchRequest = NSFetchRequest<ReminderEntity>(entityName: "ReminderEntity")
        fetchRequest.predicate = NSPredicate(format: "reminderListId == %@", reminderId.uuidString)
        do {
            let reminderEntities = try context.fetch(fetchRequest)
            var reminders = [Reminder]()
            for reminderEntity in reminderEntities {
                let reminder = try await convertReminderEntity(reminderEntity)
                reminders.append(reminder)
            }
            return reminders
        } catch let error {
            throw error
        }
    }

    func get(_ id: UUID) async throws -> Reminder? {
        let fetchRequest = NSFetchRequest<ReminderEntity>(entityName: "ReminderEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        do {
            let results = try context.fetch(fetchRequest)
            if let reminderEntity = results.first {
                let reminder = try await convertReminderEntity(reminderEntity)
                return reminder
            } else {
                return nil
            }
        } catch let error {
            throw error
        }
    }

    func add(_ reminder: Reminder) async throws {
        guard let entity = NSEntityDescription.entity(forEntityName: "ReminderEntity", in: context) else {
            return
        }
        do {
            let newReminder = ReminderEntity(entity: entity, insertInto: context)
            newReminder.id = reminder.id
            newReminder.reminderId = reminder.reminderId
            newReminder.reminderListId = reminder.reminderListId
            newReminder.title = reminder.title
            newReminder.note = reminder.note
            newReminder.state = reminder.state.rawValue
            newReminder.isAlarmRequired = reminder.isAlarmRequired
            newReminder.remindOnDate = reminder.remindOnDate
            newReminder.createdAt = reminder.createdAt
            newReminder.updatedAt = reminder.updatedAt
            if let alarmDetail = reminder.alarmDetail {
                try await alarmDetailManager.addAlarm(alarmDetail)
                guard let alarm = try await alarmDetailManager.getAlarmForReminder(reminder.id)
                        as? AlarmDetailEntity else {
                    return
                }
                newReminder.alarmDetail = alarm
                alarm.reminder = newReminder
            }
            try context.save()
        } catch let error {
            throw error
        }
    }

    func delete(_ id: UUID) async throws {
        let fetchRequest = NSFetchRequest<ReminderEntity>(entityName: "ReminderEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)

        do {
            let results = try context.fetch(fetchRequest)
            guard let reminderToDelete = results.first else {
                print("reminder with id \(id) not found.")
                return
            }
            context.delete(reminderToDelete)
            try context.save()
        } catch let error {
            throw error
        }
    }

    func update(_ id: UUID, withUpdate reminder: Reminder) async throws {
        let fetchRequest = NSFetchRequest<ReminderEntity>(entityName: "ReminderEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)

        do {
            let results = try context.fetch(fetchRequest)
            guard let reminderToUpdate = results.first else {
                print("reminder with id \(id) not found.")
                return
            }
            reminderToUpdate.id = reminder.id
            reminderToUpdate.reminderId = reminder.reminderId
            reminderToUpdate.reminderListId = reminder.reminderListId
            reminderToUpdate.title = reminder.title
            reminderToUpdate.note = reminder.note
            reminderToUpdate.state = reminder.state.rawValue
            reminderToUpdate.isAlarmRequired = reminder.isAlarmRequired
            reminderToUpdate.remindOnDate = reminder.remindOnDate
            reminderToUpdate.createdAt = reminder.createdAt
            reminderToUpdate.updatedAt = reminder.updatedAt
            if let alarmDetail = reminder.alarmDetail {
                try await alarmDetailManager.changeAlarm(reminder.id, withUpdate: alarmDetail)
                guard let alarm = try await alarmDetailManager.getAlarmForReminder(reminder.id)
                        as? AlarmDetailEntity else {
                    return
                }
                reminderToUpdate.alarmDetail = alarm
            }
            try context.save()
        } catch let error {
            throw error
        }
    }
}

private extension CoreDataReminderManager {
    func convertReminderEntity(_ reminderEntity: ReminderEntity) async throws -> Reminder {
        do {
            let alarmDetail = try await alarmDetailManager.getAlarmForReminder(reminderEntity.reminderId)
            as? AlarmDetail

            let reminder = Reminder(id: reminderEntity.id,
                                    reminderId: reminderEntity.reminderId,
                                    reminderListId: reminderEntity.reminderListId,
                                    title: reminderEntity.title,
                                    state: ReminderState(rawValue: reminderEntity.state) ?? ReminderState.todo,
                                    note: reminderEntity.note,
                                    remindOnDate: reminderEntity.remindOnDate,
                                    isAlarmRequired: reminderEntity.isAlarmRequired,
                                    alarmDetail: alarmDetail,
                                    createdAt: reminderEntity.createdAt,
                                    updatedAt: reminderEntity.updatedAt)
            return reminder
        } catch let error {
            throw error
        }
    }
}
