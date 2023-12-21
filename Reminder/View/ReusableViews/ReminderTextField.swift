//  ReminderTextField.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/17/23.
//  
//

import SwiftUI

struct ReminderTextField: View {
    @Binding var text: String
    @Binding var isFocused: Bool
    @Binding var isCompleted: Bool
    @FocusState private var focusState: Bool
    
    var placeholderText: String
    var textColor: Color
    var fontSize: Float
    
    let onAppear: (() -> Void)?
    let onSubmit: (() -> Void)?
    let lineLimit = 1
    
    var body: some View {
        TextField(placeholderText, text: $text, axis: .vertical)
            .font(.system(size: CGFloat(fontSize)))
            .textInputAutocapitalization(.never)
            .foregroundColor(textColor)
            .disableAutocorrection(true)
            .focused($focusState)
            .strikethrough(isCompleted)
            .onAppear(perform: {
                (onAppear ?? {})()
            })
            .onSubmit() {
                (onSubmit ?? {})()
            }
            .onChange(of: focusState) { _, newValue in
                isFocused = newValue
            }
            .onChange(of: text) { oldValue, newValue in
                if (oldValue != newValue) && !oldValue.isEmpty {
                    (onSubmit ?? {})()
                }
            }
            .onChange(of: isFocused) { _, newValue in
                focusState = isFocused
            }
    }
}

struct ReminderTextField_Preview: PreviewProvider {
    static var previews: some View {
        @State var text: String = "Sample text"
        @State var isFocused: Bool = false
        @State var isCompleted: Bool = true
        ReminderTextField(text: $text,
                          isFocused: $isFocused,
                          isCompleted: $isCompleted,
                          placeholderText: "",
                          textColor: Color.black, 
                          fontSize: 17.0,
                          onAppear: {},
                          onSubmit: {})
    }
}
