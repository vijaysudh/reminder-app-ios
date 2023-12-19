//  ReminderListContentView.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/16/23.
//  
//

import SwiftUI

struct ReminderListContentView: View {
    @State var viewModel = ReminderListViewModel()
    var body: some View {
        NavigationStack {
            ReminderListView(viewModel: viewModel).navigationTitle("Reminders")
        }
    }
}

#Preview {
    ReminderListContentView()
}
