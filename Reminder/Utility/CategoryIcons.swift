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
    
    func stringValue() -> String {
        switch(self) {
        case .list:
            return "list.bullet"
        case .cart:
            return "cart.fill"
        case .food:
            return "carrot.fill"
        case .bookmark:
            return "bookmark.fill"
        case .contact:
            return "person.fill"
        case .music:
            return "music.note"
        case .birthday:
            return "birthday.cake.fill"
        case .dining:
            return "fork.knife"
        case .camping:
            return "tent.fill"
        case .cricket:
            return "cricket.ball.fill"
        case .volleyball:
            return "volleyball.fill"
        case .tennis:
            return "tennisball.fill"
        case .football:
            return "football.fill"
        case .basketball:
            return "basketball.fill"
        case .baseball:
            return "baseball.fill"
        case .moon:
            return "moon.fill"
        case .sum:
            return "sun.max.fill"
        }
    }
}
