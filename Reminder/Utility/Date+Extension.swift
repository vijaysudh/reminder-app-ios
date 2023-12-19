//  Date+Extension.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/18/23.
//  
//

import Foundation


extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
