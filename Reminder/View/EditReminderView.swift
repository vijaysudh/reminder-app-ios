//  EditReminderView.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/18/23.
//  
//

import SwiftUI

struct EditReminderView: View {
    @Environment(ReminderListViewModel.self) private var viewModel
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var date = Date()
    @State private var isAlarmRequired: Bool = false
    @FocusState private var focus: FocusedField?
    @Environment(\.dismiss) var dismiss
    
    let reminderId: UUID
    
    var body: some View {
        ReminderDetailView(title: $title,
                           note: $note,
                           date: $date,
                           isAlarmRequired: $isAlarmRequired,
                           header: "Edit Reminder",
                           action: editReminder).task {
            await loadReminder()
        }
    }
}

extension EditReminderView {
    func loadReminder() async {
        guard let reminder = viewModel.getReminder(id: reminderId) else {
            return
        }
        title = reminder.title
        note = reminder.note ?? ""
        isAlarmRequired = reminder.remindOnDate != nil ? true : false
        date = reminder.remindOnDate ?? Date()
        
    }
    
    func editReminder() {
        guard let reminder = viewModel.getReminder(id: reminderId) else {
            return
        }
        var updatedReminder = reminder
        updatedReminder.title = title
        updatedReminder.note = !note.isEmpty ? note : nil
        updatedReminder.isAlarmRequired = isAlarmRequired
        updatedReminder.remindOnDate = isAlarmRequired ? date : nil
        updatedReminder.updatedAt = Date()
        viewModel.updateReminder(forId: reminderId, withUpdate: updatedReminder)
        if isAlarmRequired {
            let userInfo = ["reminderId": reminder.id.uuidString]
            LocalNotificationManager.shared.scheduleNotification(title: title, body: note, remindAt: date, userInfo: userInfo) { result in
                switch result {
                case .success(let notificationId):
                    DispatchQueue.main.async {
                        let alarmDetail = AlarmDetail(id: notificationId, reminderId: updatedReminder.id)
                        self.viewModel.updateAlarmDetail(forId: updatedReminder.id, withUpdate: alarmDetail)
                    }
                case .failure(let error):
                    let _ = print("editReminder - error: ", error.localizedDescription)
                }
            }
        }
        dismiss()
    }
}

struct EditReminderView_Preview: PreviewProvider {
    static let isAlarmRequired = false
    static var previews: some View {
        EditReminderView(reminderId: UUID()).environment(ReminderListViewModel())
    }
}
