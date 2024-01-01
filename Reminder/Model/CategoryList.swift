//  ReminderList.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/20/23.
//  
//

import Foundation

struct CategoryList: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var iconName: String
    var name: String
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
}
