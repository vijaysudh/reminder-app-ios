//  AlarmDetailRepositoryInterface.swift
//  Reminder
//
//  Created by Vijaysudh M on 1/1/24.
//  
//

import Foundation

protocol AlarmDetailRepositoryInterface {
    associatedtype T
    func getAlarmForReminder(_ reminderId: UUID) async throws -> T?
    func addAlarm(_ alarmDetail: AlarmDetail) async throws
    func deleteAlarm(_ id: UUID) async throws
    func changeAlarm(_ id: UUID, withUpdate alarmDetail: AlarmDetail) async throws
}
