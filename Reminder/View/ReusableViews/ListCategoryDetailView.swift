//  ListCategoryDetailView.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/21/23.
//
//

import SwiftUI

// Allows focus navigation in a form
enum ListCategoryFocusedField: Hashable {
    case name
}

struct ListCategoryDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var title: String
    @Binding var imageIndex: Int
    @State private var isSelected = false
    
    var gridItemLayout = [GridItem(.adaptive(minimum: 50))]
    let images = CategoryIcons.allCases
    let header: String
    let action: () -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack {
                        HStack(alignment: .center) {
                            Spacer()
                            IconImageView(isSelected: isSelected, 
                                          imageName: images.filter { $0.rawValue == imageIndex }.first?.stringValue() ?? images[0].stringValue(),
                                          backgroundColor: Color.blue,
                                          iconColor: Color.white,
                                          iconSize: 60)
                            Spacer()
                        }.padding()
                        LargeTextField(text: $title, placeholder: "List name", onSubmit: {})
                    }.background(Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(8.0)
                        .shadow(radius: 1.0))
                        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                    
                    CategoryIconView(imageIndex: $imageIndex)
                }.navigationTitle(header)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: {
                                dismiss()
                            }, label: {
                                Label("Close", systemImage: "xmark")
                                    .labelStyle(.iconOnly)
                                    .fontWeight(.light)
                            })
                        }
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: action,
                                   label: {
                                Text("Save").fontWeight(.medium)
                            })
                        }
                    }
            }
        }
    }
}

//private extension ListCategoryDetailView {
//    func checkTitle() {
//        print("Updated title: \(title)")
//    }
//}

struct ListCategoryDetailView_Preview: PreviewProvider {
    static var previews: some View {
        @State var title: String = "List title"
        @State var imageIndex: Int = 0
        @State var selectedIcon: String = "list.bullet"
        ListCategoryDetailView(title: $title,
                               imageIndex: $imageIndex,
                               header: "New List",
                               action: {})
    }
}
