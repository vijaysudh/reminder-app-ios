//  AddReminderView.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/16/23.
//  
//

import SwiftUI

// Allows focus navigation in a form
enum FocusedField: Hashable {
    case name
    case note
}

struct AddReminderView: View {
    @Environment(ReminderListViewModel.self) private var viewModel
    @State private var title: String = ""
    @State private var note: String = ""
    @State private var date = Date()
    @State private var isAlarmRequired: Bool = false
    @FocusState private var focus: FocusedField?
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
        let reminder = Reminder(title: title, state: .todo, note: note, remindOnDate: date, isAlarmRequired: isAlarmRequired)
        viewModel.add(reminder: reminder)
        if let date = date, isAlarmRequired {
            ReminderNotification().scheduleNotification(title: title, body: note, remindAt: date)
        }
        dismiss()
    }
}



#Preview {
    AddReminderView().environment(ReminderListViewModel())
}
