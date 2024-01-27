//  ReminderListViewModel.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/16/23.
//  
//

import Foundation

protocol ReminderListInterface {
    var reminderCategoryId: UUID { get }
    var categoryName: String { get }
    // Create
    func add(reminder: Reminder)
    // Read
    func loadReminders() async
    func getAllReminders() -> [Reminder]
    func getReminder(id: UUID) -> Reminder?
    // Update
    func updateReminder(forId id: UUID, withUpdate update: Reminder)
    func updateAlarmDetail(forId id: UUID, withUpdate update: AlarmDetail)
    // Delete
    func deleteReminder(id: UUID)
}

@Observable class ReminderListViewModel: ReminderListInterface {
    // var state: ViewState = .idle
    var reminderCategoryId: UUID
    var categoryName: String
    private var reminderRepository: any ReminderRepositoryInterface
    private var reminders: [Reminder] = [Reminder]()

    init(reminderCategoryId: UUID, categoryName: String, reminderRepository: any ReminderRepositoryInterface) {
        self.reminderCategoryId = reminderCategoryId
        self.reminderRepository = reminderRepository
        self.categoryName = categoryName
    }

    func add(reminder: Reminder) {
        reminders.append(reminder)
        Task {
            do {
                try await reminderRepository.add(reminder)
            } catch let error {
                print("Unable to add reminder due to error: " + error.localizedDescription)
            }
        }
    }

    func deleteReminder(id: UUID) {
        guard let index = reminders.firstIndex(where: { $0.id == id }) else {
            return
        }
        reminders.remove(at: index)
        Task {
            do {
                try await reminderRepository.delete(id)
            } catch let error {
                print("Unable to delete reminder with \(id.uuidString) due to error: " + error.localizedDescription)
            }
        }
    }

    func updateReminder(forId id: UUID, withUpdate update: Reminder) {
        guard let index = reminders.firstIndex(where: { $0.id == id }) else {
            return
        }
        reminders[index] = update
        Task {
            do {
                try await reminderRepository.update(id, withUpdate: update)
            } catch let error {
                print("Unable to update reminder with \(id.uuidString) due to error: " + error.localizedDescription)
            }
        }
    }

    func updateAlarmDetail(forId id: UUID, withUpdate update: AlarmDetail) {
        guard let index = reminders.firstIndex(where: { $0.id == id }) else {
            return
        }
        var updateReminder = reminders[index]
        updateReminder.alarmDetail = update
        updateReminder.updatedAt = Date()
        reminders[index] = updateReminder

        Task {
            try await reminderRepository.update(id, withUpdate: reminders[index])
        }
    }

    func getAllReminders() -> [Reminder] {
        return reminders.filter { $0.reminderListId == reminderCategoryId }
    }

    func getReminder(id: UUID) -> Reminder? {
        return reminders.first(where: { $0.id == id })
    }

    func loadReminders() async {
        do {
            guard let fetchedReminders = try await reminderRepository.list(forReminderId: reminderCategoryId)
                    as? [Reminder] else {
                return
            }
            reminders.removeAll()
            for reminder in fetchedReminders {
                reminders.append(reminder)
            }
        } catch let error {
            print("Error loading reminders: " + error.localizedDescription)
        }
    }
}
