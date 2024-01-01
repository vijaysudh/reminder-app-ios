//  CategoryListContentView.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/20/23.
//  
//

import SwiftUI

struct CategoryListContentView<Factory: BaseCategoryViewModelFactory>: View {
    @State var viewModel: CategoryViewModel
    @State private var isAddCategorySheetDisplayed = false
    
    init(factory: Factory) {
        _viewModel = State(wrappedValue: factory.createModel())
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                List(viewModel.getAllCategories()) { reminderCategory in
                    NavigationLink {
                        ReminderListContentView(factory: ReminderListViewModelFactory(reminderCategoryId: reminderCategory.id))
                    } label: {
                        IconImageView(isSelected: false,
                                      imageName: reminderCategory.iconName,
                                      backgroundColor: Color.blue,
                                      iconColor: Color.white,
                                      iconSize: 35)
                        Text(reminderCategory.name).fontWeight(.light)
                    }.swipeActions {
                        Button {
                            viewModel.deleteCategory(id: reminderCategory.id)
                        } label: {
                            Image(systemName:"trash.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .font(Font.system(size: 60, weight: .light))
                                .foregroundColor(.blue)
                        }.tint(.red)
                        
                        Button {
                            print("Call Edit!") // TODO: Introduce the call to Edit the List
                        } label: {
                            Image(systemName:"info.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .font(Font.system(size: 60, weight: .light))
                                .foregroundColor(.blue)
                        }.tint(.gray)
                    }
                }
                .navigationTitle("My List")
                .fontWeight(.light)
                Spacer()
                HStack(alignment: .top) {
                    AddButton(isSheetDisplayed: isAddCategorySheetDisplayed, title: "Add List", iconName: "text.badge.plus") {
                        AddCategoryListView()
                            .environment(viewModel)
                    }
                    Spacer()
                }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }.task {
                await viewModel.loadCategoryList()
            }
        }
    }
}

struct CategoryListContentView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListContentView(factory: CategoryViewModelFactory())
    }
}
