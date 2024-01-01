//  AddButton.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/17/23.
//  
//

import SwiftUI

struct AddButton<Destination>: View where Destination : View {
    @State var isSheetDisplayed: Bool = false
    var title: String
    let destination: Destination
    let iconName: String

    init(isSheetDisplayed: Bool = false,
         title: String,
         iconName: String,
         @ViewBuilder destination: @escaping () -> Destination) {
        self.destination = destination()
        self.title = title
        self.iconName = iconName
        self.isSheetDisplayed = isSheetDisplayed
    }
    
    var body: some View {
        Button(action: {
            isSheetDisplayed.toggle()
        }, label: {
            Image(systemName:iconName)
                .resizable()
                .font(Font.system(size: 60, weight: .light))
                .frame(width: 25, height: 25)
                .foregroundColor(.blue)
                .fontWeight(.light)
            Text(title)
                .fontWeight(.light)
                .foregroundColor(.blue)
        }).padding(
            EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10))
        .sheet(isPresented: $isSheetDisplayed, content: {
            destination
        })
    }
}

struct AddButton_Previews: PreviewProvider {
    static var previews: some View {
        let view = { AddReminderView().environment(ReminderListViewModelFactory(reminderCategoryId: UUID()).createModel()) }
        AddButton(title: "Add Reminder", iconName: "plus.circle", destination: view)
    }
}
