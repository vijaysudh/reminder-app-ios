//  ReminderStateButton.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/17/23.
//  
//

import SwiftUI

struct ReminderStateButton: View {
    let action: () -> Void
    @Binding var stateImageName: String

    var body: some View {
        Button(action: action,
               label: {
            Image(systemName: stateImageName)
                .resizable()
                .font(Font.system(size: 60, weight: .light))
                .frame(width: 25, height: 25)
                .foregroundColor(.blue)
        }).buttonStyle(.borderless)
    }
}

private extension ReminderStateButton {
    func setReminderImage(forState state: ReminderState) {
        // completed - circle.inset.filled
        // not completed - circle
        // empty - circle.dotted
        var imageName = ""
        switch state {
        case .todo:
            imageName = "circle"
        case .completed:
            imageName = "circle.inset.filled"
        }
        self.stateImageName = imageName
    }
}

struct ReminderStateButtonPreview: PreviewProvider {
    static var previews: some View {
        @State var imageString = "circle"
        ReminderStateButton(action: {}, stateImageName: $imageString)
    }
}
