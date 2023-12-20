//  ReminderListViewModel.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/16/23.
//  
//

import Foundation

protocol ReminderListProtocol {
    func add(reminder: Reminder)
    func deleteReminder(id: UUID)
    func getAllReminders() -> [Reminder]
    func getReminder(id: UUID) -> Reminder?
    func loadReminders() async
}

@Observable class ReminderListViewModel: ReminderListProtocol {
    private var reminders: [Reminder] = [Reminder]()
    
    func add(reminder: Reminder) {
        reminders.append(reminder)
    }
    
    func deleteReminder(id: UUID) {
        guard let index = reminders.firstIndex(where: { $0.id == id }) else {
            return
        }
        reminders.remove(at: index)
    }
    
    func updateReminder(forId id: UUID, withUpdate update: Reminder) {
        guard let index = reminders.firstIndex(where: { $0.id == id }) else {
            return
        }
        reminders[index] = update
    }
    
    func updateAlarmDetail(forId id: UUID, withUpdate update: AlarmDetail) {
        guard let index = reminders.firstIndex(where: { $0.id == id }) else {
            return
        }
        var updateReminder = reminders[index]
        updateReminder.alarmDetail = update
        updateReminder.updatedAt = Date()
        reminders[index] = updateReminder
    }
    
    func getAllReminders() -> [Reminder] {
        return reminders
    }
    
    func getReminder(id: UUID) -> Reminder? {
        return reminders.first(where: { $0.id == id })
    }
    
    // TODO: Change the loading to local peristed data
    func loadReminders() async {
        for index in 0..<10  {
            add(reminder: Reminder(title: "Sample Reminder \(index+1)", state: .todo, updatedAt: Date()))
        }
    }
}

