//  ReminderRepositoryInterface.swift
//  Reminder
//
//  Created by Vijaysudh M on 1/1/24.
//  
//

import Foundation

protocol ReminderRepositoryInterface {
    associatedtype T
    func list(forReminderId reminderId: UUID) async throws -> [T]
    func get(_ id: UUID) async throws -> T?
    func add(_ reminder: Reminder) async throws
    func delete(_ id: UUID) async throws
    func update(_ id: UUID, withUpdate reminder: Reminder) async throws
}
