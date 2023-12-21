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
    var reminderListId: UUID = UUID(uuidString: "3469243d-5909-4703-a05c-0353ed59e060") ?? UUID() // TODO: Temporary until the list view is ready
    var title: String
    var state: ReminderState
    var note: String?
    var remindOnDate: Date?
    var isAlarmRequired: Bool = false
    var alarmDetail: AlarmDetail?
    var updatedAt = Date()
}

// Structure to track reminder notifications created when alarm is required
struct AlarmDetail: Identifiable, Hashable, Codable {
    var id: UUID
    var reminderId: UUID
}

