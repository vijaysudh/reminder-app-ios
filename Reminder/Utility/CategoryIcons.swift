//  CategoryIcons.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/22/23.
//  
//

import Foundation

enum CategoryIcons: Int, CaseIterable {
    case list = 1
    case cart = 2
    case food = 3
    case bookmark = 4
    case contact = 5
    case music = 6
    case birthday = 7
    case dining = 8
    case camping = 9
    case cricket = 10
    case volleyball = 11
    case tennis = 12
    case football = 13
    case basketball = 14
    case baseball = 15
    case moon = 16
    case sum = 17

    private static let icons: [CategoryIcons: String] = [.list: "list.bullet",
                                                         .cart: "cart.fill",
                                                         .food: "carrot.fill",
                                                         .bookmark: "bookmark.fill",
                                                         .contact: "person.fill",
                                                         .music: "music.note",
                                                         .birthday: "birthday.cake.fill",
                                                         .dining: "fork.knife",
                                                         .camping: "tent.fill",
                                                         .cricket: "cricket.ball.fill",
                                                         .volleyball: "volleyball.fill",
                                                         .tennis: "tennisball.fill",
                                                         .football: "football.fill",
                                                         .basketball: "basketball.fill",
                                                         .baseball: "baseball.fill",
                                                         .moon: "moon.fill",
                                                         .sum: "sun.max.fill"]

    func stringValue() -> String {
        return CategoryIcons.icons[self] ?? ""
    }
}
