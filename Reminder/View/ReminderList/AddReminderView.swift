//  AddReminderView.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/16/23.
//  
//

import SwiftUI

struct AddReminderView: View {
    @Environment(ReminderListViewModel.self) private var viewModel
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var date = Date()
    @State private var isAlarmRequired: Bool = false
    @FocusState private var focus: ReminderFocusedField?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ReminderDetailView(title: $title,
                           note: $note,
                           date: $date,
                           isAlarmRequired: $isAlarmRequired,
                           header: "Add Reminder",
                           action: addReminder)
    }
}

private extension AddReminderView {
    func addReminder() {
        let note = !note.isEmpty ? note : nil
        let date = isAlarmRequired ? date : nil
        let reminder = Reminder(reminderListId: viewModel.reminderCategoryId,
                                title: title,
                                state: .todo,
                                note: note,
                                remindOnDate: date,
                                isAlarmRequired: isAlarmRequired,
                                updatedAt: Date())
        viewModel.add(reminder: reminder)
        if let date = date, isAlarmRequired {
            let userInfo = ["reminderId": reminder.id.uuidString]
            LocalNotificationManager.shared.scheduleNotification(title: title,
                                                                 body: note,
                                                                 remindAt: date,
                                                                 userInfo: userInfo) { result in
                switch result {
                case .success(let notificationId):
                    DispatchQueue.main.async {
                        let alarmDetail = AlarmDetail(id: notificationId, reminderId: reminder.id)
                        self.viewModel.updateAlarmDetail(forId: reminder.id, withUpdate: alarmDetail)
                    }
                case .failure(let error):
#if DEBUG
                    print("addReminder - error: ", error.localizedDescription)
#endif
                }
            }
        }
        dismiss()
    }
}

#Preview {
    AddReminderView().environment(ReminderListViewModelFactory(reminderCategoryId: UUID(),
                                                               categoryName: "Reminders").createModel())
}
