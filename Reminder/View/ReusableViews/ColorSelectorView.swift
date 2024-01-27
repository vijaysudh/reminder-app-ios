//  ColorSelectorView.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/22/23.
//  
//

import SwiftUI

struct ColorSelectorView: View {
    var backgroundColor: Color
    var iconSize: CGFloat

    var body: some View {
        Image(systemName: "")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding(10)
            .frame(width: iconSize, height: iconSize)
            .foregroundColor(.white)
            .background(backgroundColor)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay(Circle().stroke(Color(uiColor: .darkGray), lineWidth: 4))
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .font(Font.system(size: iconSize, weight: .light))
            .shadow(radius: 2)
    }
}

#Preview {
    ColorSelectorView(backgroundColor: .blue, iconSize: 35)
}
