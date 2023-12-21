//  ReminderApp.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/16/23.
//  
//

import SwiftUI

@main
struct ReminderApp: App {
    var body: some Scene {
        WindowGroup {
            ReminderListCategoryView(viewModel: ReminderCategoryViewModel())
        }
    }
}
