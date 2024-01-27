//  ReminderListRow.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/17/23.
//  
//

import SwiftUI

struct ReminderListRow: View {
    @Environment(ReminderListViewModel.self) private var viewModel
    @State private var isEditReminderSheetDisplayed = false
    @State var reminderText: String = ""
    @State var reminderNote: String = ""
    // @State var remindOnDate: Date = Date()
    @State var isReminderFocused: Bool = false
    @State var isNoteFocused: Bool = false
    @State var stateImageName: String = "circle"
    @State var isCompleted: Bool = false

    var reminderId: UUID

    var body: some View {
        HStack(alignment: .top) {
            ReminderStateButton(action: updateReminderState, stateImageName: $stateImageName)
                .padding([.leading], 10)
            VStack(alignment: .leading) {
                ReminderTextField(text: $reminderText,
                                  isFocused: $isReminderFocused,
                                  isCompleted: $isCompleted,
                                  placeholderText: "",
                                  textColor: Color.black,
                                  fontSize: 17,
                                  onAppear: reminderTextOnAppear,
                                  onSubmit: updateReminder)
                .alignmentGuide(.listRowSeparatorLeading) {
                    $0[.leading]
                }
                let note = getReminder()?.note ?? ""
                if !note.isEmpty || isReminderFocused || isNoteFocused {
                    ReminderTextField(text: $reminderNote,
                                      isFocused: $isNoteFocused,
                                      isCompleted: $isCompleted,
                                      placeholderText: "Add note",
                                      textColor: Color.gray,
                                      fontSize: 14,
                                      onAppear: reminderNoteOnAppear,
                                      onSubmit: updateReminder)
                }
                let date = getReminder()?.remindOnDate?.formatted(date: .abbreviated, time: .shortened) ?? ""
                if !date.isEmpty {
                    HStack {
                        Image(systemName: "alarm").fontWeight(.light)
                        Text(date)
                            .foregroundColor(Color.gray)
                            .font(.system(size: CGFloat(14)))
                            .fontWeight(.light)
                    }
                }
            }

            Button(action: {
                isReminderFocused = false
                isEditReminderSheetDisplayed = true
            }, label: {
                Image(systemName: "info.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .font(Font.system(size: 60, weight: .light))
                    .foregroundColor(.blue)
            })
            .buttonStyle(.borderless)
            .opacity((isReminderFocused || isNoteFocused) ? 1 : 0)
            .sheet(isPresented: $isEditReminderSheetDisplayed) {
                EditReminderView(reminderId: reminderId)
                    .environment(viewModel)
            }.padding([.leading], 10)
        }
        .padding([.leading, .trailing], 5.0)
    }
}

// UI Functions
private extension ReminderListRow {
    func reminderTextOnAppear() {
        if let reminder = getReminder() {
            reminderText = reminder.title
        }
    }

    func reminderNoteOnAppear() {
        if let reminder = getReminder(), let note = reminder.note {
            reminderNote = note
        }
    }

    func updateReminder() {
        if let reminder = getReminder() {
            var updatedReminder = reminder
            updatedReminder.title = reminderText
            updatedReminder.note = reminderNote
            updatedReminder.updatedAt = Date()
            viewModel.updateReminder(forId: reminder.id, withUpdate: updatedReminder)
        }
    }

    func setReminderImage(forState state: ReminderState) {
        self.stateImageName = state.stateIcon()
    }

    func getReminder() -> Reminder? {
        guard let reminder = viewModel.getReminder(id: reminderId) else {
            return nil
        }
        return reminder
    }

    func updateReminderState() {
        guard let reminder = getReminder() else {
            return
        }
        var state: ReminderState = reminder.state

        if reminder.state == .completed {
            state = .todo
            isCompleted = false
        } else {
            state = .completed
            isCompleted = true
        }
        var updatedReminder = reminder
        updatedReminder.state = state
        updatedReminder.updatedAt = Date()
        viewModel.updateReminder(forId: reminder.id, withUpdate: updatedReminder)
        setReminderImage(forState: state)
    }
}

struct ReminderListRowPreviews: PreviewProvider {
    static let reminder = Reminder(reminderListId: UUID(),
                                   title: "Sample Reminder",
                                   state: .todo,
                                   note: "Note",
                                   updatedAt: Date())
    static var previews: some View {
        ReminderListRow(reminderId: reminder.id)
            .environment(ReminderListViewModelFactory(reminderCategoryId: UUID(),
                                                      categoryName: "Reminders").createModel())
    }
}
