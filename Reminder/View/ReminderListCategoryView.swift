//  ReminderListCategoryView.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/20/23.
//  
//

import SwiftUI

struct ReminderListCategoryView: View {
    @State var viewModel = ReminderCategoryViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                List(viewModel.getAllReminderCategories(), id: \.updatedAt) { reminderCategory in
                    NavigationLink {
                        ReminderListContentView(factory: ReminderListViewModelFactory())
                    } label: {
                        Label(reminderCategory.name, systemImage: "list.bullet.circle")
                    }
                }
                .navigationTitle("My List")
            }.task {
                await viewModel.loadReminderCategoryList()
            }
        }
    }
}

struct ReminderListCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderListCategoryView(viewModel: ReminderCategoryViewModel())
    }
}

