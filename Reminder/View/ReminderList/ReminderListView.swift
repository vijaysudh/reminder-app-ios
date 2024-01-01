//  ReminderListView.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/16/23.
//  
//

import SwiftUI

struct ReminderListView: View {
    @State var viewModel: ReminderListViewModel
    @State private var isAddReminderSheetDisplayed = false
    
    var body: some View {
        VStack(alignment: .leading) {
            List(viewModel.getAllReminders()) { reminder in
                ReminderListRow(reminderId: reminder.id).environment(viewModel)
                    .listSectionSeparator(.hidden, edges: [.top, .bottom])
            }
            .listStyle(.plain)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            Spacer()
            HStack(alignment: .top) {
                AddButton(isSheetDisplayed: isAddReminderSheetDisplayed, title: "Add Reminder", iconName: "plus.circle") {
                    AddReminderView()
                        .environment(viewModel)
                }
                Spacer()
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        }.background(.ultraThickMaterial)
            .task {
                await viewModel.loadReminders()
            }
    }
}

struct ReminderListView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderListView(viewModel: ReminderListViewModelFactory(reminderCategoryId: UUID()).createModel())
    }
}
