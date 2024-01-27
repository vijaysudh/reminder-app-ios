//  CategoryIconView.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/22/23.
//  
//

import SwiftUI

struct CategoryIconView: View {
    @Binding var imageIndex: Int
    @State private var selectedState: [Int: Bool] = [Int: Bool]()

    var isSelected: Bool = false
    let gridItemLayout = [GridItem(.adaptive(minimum: 50))]
    let images = CategoryIcons.allCases.sorted(by: { $0.rawValue < $1.rawValue })

    var body: some View {
        VStack {
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                ForEach(images, id: \.self) { imageName in
                    Button {
                        imageIndex = imageName.rawValue
                        selectedState.removeAll()
                        selectedState[imageIndex] = true
                    } label: {
                        IconImageView(isSelected: selectedState[imageName.rawValue] != nil ? true : false,
                                      imageName: imageName.stringValue(),
                                      backgroundColor: Color(uiColor: .systemGray5),
                                      iconColor: Color.black,
                                      iconSize: 35,
                                      hasShadow: true)
                    }
                }
            }.padding()
        }
        .background(Rectangle()
            .foregroundColor(.white)
            .cornerRadius(8.0)
            .shadow(radius: 1.0))
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
    }
}

struct CategoryIconViewPreview: PreviewProvider {
    static var previews: some View {
        @State var imageIndex = 0
        CategoryIconView(imageIndex: $imageIndex)
    }
}
