//  AddReminderButton.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/17/23.
//  
//

import SwiftUI

struct AddReminderButton<Destination>: View where Destination : View {
    @State var isAddReminderSheetDisplayed: Bool = false
    let destination: Destination

    init(isAddReminderSheetDisplayed: Bool = false, @ViewBuilder destination: @escaping () -> Destination) {
        self.destination = destination()
        self.isAddReminderSheetDisplayed = isAddReminderSheetDisplayed
    }
    
    var body: some View {
        Button(action: {
            isAddReminderSheetDisplayed.toggle()
        }, label: {
            Image(systemName:"plus.circle.fill")
                .resizable()
                .font(Font.system(size: 60, weight: .light))
                .frame(width: 25, height: 25)
                .foregroundColor(.blue)
            Text("Add Reminder")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(.blue)
        }).padding(
            EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 10))
        .sheet(isPresented: $isAddReminderSheetDisplayed, content: {
            destination
        })
    }
}

struct AddReminderButton_Previews: PreviewProvider {
    static var previews: some View {
        let view = { AddReminderView().environment(ReminderListViewModelFactory().createModel()) }
        AddReminderButton(destination: view)
    }
}
