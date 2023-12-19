//  ReminderDetailView.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/18/23.
//  
//

import SwiftUI

struct ReminderDetailView: View {
    @Binding var title: String
    @Binding var note: String
    @Binding var date: Date
    @FocusState private var focus: FocusedField?
    @Environment(\.dismiss) var dismiss
    @Binding var isAlarmRequired: Bool
    
    let header: String
    let action: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("reminder")) {
                    TextField("Title", text: $title, axis: .vertical)
                        .font(.system(size: 16))
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focus, equals: .name)
                        .onSubmit {
                            focus = .note
                        }
                    TextField("Note", text: $note, axis: .vertical)
                        .font(.system(size: 16))
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focus, equals: .note)
                    
                    Toggle("Set Alarm", isOn: $isAlarmRequired)
                    if(isAlarmRequired) {
                        DatePicker(selection: $date,
                                   label: {
                            Image(systemName: "calendar")
                                .resizable()
                                .foregroundColor(Color.red)
                                .frame(width: 30, height: 30)
                                .tint(Color.red)
                        })
                    }
                }.onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        focus = .name
                    }
                }
            }.navigationTitle(header)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Cancel")
                        })
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: action, label: {
                            Text("Done")
                        })
                    }
                }
        }
    }
}

struct ReminderDetailView_Preview: PreviewProvider {
    static var previews: some View {
        @State var title: String = "Reminder title"
        @State var note: String = "Some note"
        @State var date: Date = Date()
        @State var isAlarmRequired: Bool = false
        ReminderDetailView(title: $title,
                           note: $note,
                           date: $date,
                           isAlarmRequired: $isAlarmRequired,
                           header: "Add Reminder",
                           action: {})
    }
}
