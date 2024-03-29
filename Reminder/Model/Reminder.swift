//  Reminder.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/16/23.
//  
//

import Foundation

enum ReminderState: String, Codable {
    case todo = "TODO"
    case completed = "COMPLETED"

    func stateIcon() -> String {
        var iconName = "circle.dotted"
        switch self {
        case .todo:
            iconName = "circle"
        case .completed:
            iconName = "circle.inset.filled"
        }
        return iconName
    }
}

struct Reminder: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var reminderId: UUID = UUID()
    var reminderListId: UUID
    var title: String
    var state: ReminderState
    var note: String?
    var remindOnDate: Date?
    var isAlarmRequired: Bool = false
    var alarmDetail: AlarmDetail?
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
}

// Structure to track reminder notifications created when alarm is required
struct AlarmDetail: Identifiable, Hashable, Codable {
    var id: UUID
    var reminderId: UUID
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
}
