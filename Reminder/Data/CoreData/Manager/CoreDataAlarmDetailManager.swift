//  CoreDataAlarmDetailManager.swift
//  Reminder
//
//  Created by Vijaysudh M on 1/1/24.
//  
//

import Foundation
import CoreData

class CoreDataAlarmDetailManager: AlarmDetailRepositoryInterface {
    typealias T = AlarmDetail

    let context = PersistenceController.shared.container.viewContext

    func getAlarmForReminder(_ reminderId: UUID) async throws -> AlarmDetail? {
        let fetchRequest = NSFetchRequest<AlarmDetailEntity>(entityName: "AlarmDetailEntity")

        fetchRequest.predicate = NSPredicate(format: "id == %@", reminderId.uuidString)
        do {
            let results = try context.fetch(fetchRequest)
            if let alarmDetailEntity = results.first {
                return convertAlarmDetailEntity(alarmDetailEntity)
            } else {
                return nil
            }
        } catch let error {
            throw error
        }
    }

    func addAlarm(_ alarmDetail: AlarmDetail) async throws {
        guard let entity = NSEntityDescription.entity(forEntityName: "AlarmDetailEntity", in: context) else {
            return
        }
        let newAlarmDetail = NSManagedObject(entity: entity, insertInto: context)
        newAlarmDetail.setValue(alarmDetail.id, forKey: "id")
        newAlarmDetail.setValue(alarmDetail.createdAt, forKey: "createdAt")
        newAlarmDetail.setValue(alarmDetail.updatedAt, forKey: "updatedAt")
        do {
            try context.save()
        } catch let error {
            throw error
        }
    }

    func deleteAlarm(_ id: UUID) async throws {
        let fetchRequest = NSFetchRequest<AlarmDetailEntity>(entityName: "AlarmDetailEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)

        do {
            let results = try context.fetch(fetchRequest)
            guard let alarmDetailToDelete = results.first else {
                print("Alarm detail with id \(id) not found.")
                return
            }
            context.delete(alarmDetailToDelete)
            try context.save()
        } catch let error {
            throw error
        }
    }

    func changeAlarm(_ id: UUID, withUpdate alarmDetail: AlarmDetail) async throws {
        do {
            try await deleteAlarm(id)
            try await addAlarm(alarmDetail)
        } catch let error {
            throw error
        }
    }
}

private extension CoreDataAlarmDetailManager {
    func convertAlarmDetailEntity(_ alarmDetailEntity: AlarmDetailEntity) -> AlarmDetail? {
        guard let reminderId = alarmDetailEntity.reminder?.id else {
            return nil
        }

        let alarmDetail = AlarmDetail(id: alarmDetailEntity.id,
                                      reminderId: reminderId,
                                      createdAt: alarmDetailEntity.createdAt,
                                      updatedAt: alarmDetailEntity.updatedAt)
        return alarmDetail
    }
}
