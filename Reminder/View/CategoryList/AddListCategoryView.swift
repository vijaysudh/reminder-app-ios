//  AddCategoryListView.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/21/23.
//  
//

import SwiftUI

struct AddCategoryListView: View {
    @Environment(CategoryViewModel.self) private var viewModel
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State var imageIndex: Int = 0

    var body: some View {
        ListCategoryDetailView(title: $title,
                               imageIndex: $imageIndex,
                               header: "New List",
                               action: addCategory)
    }
}

private extension AddCategoryListView {
    func addCategory() {
        let image = CategoryIcons(rawValue: imageIndex) ?? CategoryIcons.list
        let category = CategoryList(iconName: image.stringValue(), name: title)

        Task {
            do {
                try await viewModel.add(categoryList: category)
            } catch let error {
                print("Error adding category: " + error.localizedDescription)
            }
        }
        dismiss()
    }
}

#Preview {
    AddCategoryListView()
}
