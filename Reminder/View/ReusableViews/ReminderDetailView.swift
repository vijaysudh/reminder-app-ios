//  ReminderDetailView.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/18/23.
//  
//

import SwiftUI

// Allows focus navigation in a form
enum ReminderFocusedField: Hashable {
    case name
    case note
}

struct ReminderDetailView: View {
    @Binding var title: String
    @Binding var note: String
    @Binding var date: Date
    @FocusState private var focus: ReminderFocusedField?
    @Environment(\.dismiss) var dismiss
    @Binding var isAlarmRequired: Bool
    @State var shouldDisplayDatePicker: Bool = false
    @State private var showAlert = false

    let header: String
    let action: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Reminder")) {
                    TextField("Title", text: $title, axis: .vertical)
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focus, equals: .name)
                        .onSubmit {
                            focus = .note
                        }
                    TextField("Note", text: $note, axis: .vertical)
                        .font(.system(size: 16))
                        .fontWeight(.light)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .focused($focus, equals: .note)

                    Toggle("Set Alarm", isOn: $isAlarmRequired)
                        .onChange(of: isAlarmRequired) {_, newValue in
                            if newValue {
                                checkLocalNotificationAuthorization()
                            }
                        }
                        .fontWeight(.light)
                        .alert("Notification Settings", isPresented: $showAlert) {
                            Button("Settings", role: .destructive) {
                                openAppSettings()
                            }
                            Button("Cancel", role: .cancel) {
                                 isAlarmRequired = false
                            }
                        } message: {
                            Text("Notification settings needs to be turned on to set reminders")
                                .fontWeight(.light)
                        }

                    if shouldDisplayDatePicker && isAlarmRequired {
                        DatePicker(selection: $date,
                                   label: {
                            Image(systemName: "calendar")
                                .resizable()
                                .foregroundColor(Color.red)
                                .font(Font.system(size: 60, weight: .light))
                                .frame(width: 30, height: 30)
                                .tint(Color.red)
                        }).fontWeight(.light)
                    }
                }
                .headerProminence(.increased)
                .fontWeight(.medium)
                .onAppear {
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
                            Label("Close", systemImage: "xmark")
                                .labelStyle(.iconOnly)
                                .fontWeight(.light)
                        })
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: action, label: {
                            Text("Save").fontWeight(.medium)
                        })
                    }
                }
        }
    }
}

private extension ReminderDetailView {
    func checkLocalNotificationAuthorization() {
        LocalNotificationManager.shared.checkAuthorization { result in
            switch result {
            case .success:
                shouldDisplayDatePicker = true
            case .failure:
                shouldDisplayDatePicker = false
                showAlert = true
            }
        }
    }

    func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:]) { success in
                if success {
                    print("Opened Notification Settings successfully.")
                } else {
                    print("Failed to open Notification Settings.")
                }
            }
        }
    }
}

struct ReminderDetailViewPreview: PreviewProvider {
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
