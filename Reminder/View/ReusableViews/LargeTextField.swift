//  LargeTextField.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/22/23.
//  
//

import SwiftUI

struct LargeTextField: View {
    @FocusState private var focus: ListCategoryFocusedField?
    @Binding var text: String
    let placeholder: String
    let onSubmit: (() -> Void)?

    var body: some View {
        TextField(placeholder, text: $text)
            .padding([.leading], 10)
            .font(.system(size: 24))
            .fontWeight(.light)
            .textInputAutocapitalization(.sentences)
            .disableAutocorrection(true)
            .focused($focus, equals: .name)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(uiColor: .systemGray4))
            .foregroundStyle(.black)
            .cornerRadius(12)
            .padding()
            .onSubmit {
                (onSubmit ?? {})()
            }
            .onChange(of: text) { oldValue, newValue in
                if (oldValue != newValue) && !oldValue.isEmpty {
                    (onSubmit ?? {})()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    focus = .name
                }
            }
    }
}

struct LargeTextFieldPreview: PreviewProvider {
    static var previews: some View {
        @State var text: String = ""
        LargeTextField(text: $text, placeholder: "List name", onSubmit: {})
    }
}
