//  ViewState.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/21/23.
//  
//

import Foundation

enum ViewState {
    case idle
    case loading
    case success(data: Any)
    case error(error: Error)
}
