//  ReminderListContentView.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/16/23.
//  
//

import SwiftUI

struct ReminderListContentView<Factory: BaseReminderViewModelFactory>: View {
    let publisher = NotificationCenter.default.publisher(for: LocalNotificationManager.shared.notificationName)
    @State var viewModel: ReminderListViewModel
    
    init(factory: Factory) {
        _viewModel = State(wrappedValue: factory.createModel())
    }
    
    var body: some View {
        NavigationStack {
            ReminderListView(viewModel: viewModel)
                .navigationTitle("Reminders")
                .fontWeight(.light)
                .onReceive(publisher) { data in
                    guard let notification = data.object as? UNNotificationContent else {
                        return
                    }
                    print("Notification: ", notification) // TODO: Work on a Reminder Display View
                    LocalNotificationManager.shared.clearDeliveredNotifications()
                }
        }
    }
}

#Preview {
    ReminderListContentView(factory: ReminderListViewModelFactory(reminderCategoryId: UUID()))
}
