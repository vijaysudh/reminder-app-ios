//  ReminderList.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/20/23.
//  
//

import Foundation

struct ReminderCategoryList: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var name: String
}
