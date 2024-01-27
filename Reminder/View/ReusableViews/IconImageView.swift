//  IconImageView.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/22/23.
//  
//

import SwiftUI

struct IconImageView: View {
    var isSelected: Bool
    var imageName: String
    var backgroundColor: Color
    var iconColor: Color
    var iconSize: CGFloat
    var hasShadow: Bool

    var body: some View {
        Image(systemName: imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(10)
            .frame(width: iconSize, height: iconSize)
            .foregroundColor(iconColor)
            .background(backgroundColor)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: isSelected ? 4 : 0)
                    .stroke(!isSelected ? backgroundColor: Color(uiColor: .systemGray3), lineWidth: isSelected ? 4 : 0)
                    .frame(width: iconSize+10, height: iconSize+10)
            )
            .font(Font.system(size: iconSize, weight: .light))
            .shadow(color: !isSelected ? backgroundColor.opacity(hasShadow ? 1 : 0) :
                        Color(uiColor: .darkGray).opacity(0), radius: 2)
    }
}

struct IconImageViewPreview: PreviewProvider {
    static var previews: some View {
        let isSelected: Bool = false
        let imageName = CategoryIcons.food.stringValue()
        let backgroundColor = Color(uiColor: .systemGray5)
        let iconColor = Color.black
        let size: CGFloat = 60
        IconImageView(isSelected: isSelected,
                      imageName: imageName,
                      backgroundColor: backgroundColor,
                      iconColor: iconColor,
                      iconSize: size,
                      hasShadow: true)
    }
}
