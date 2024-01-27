//  CategoryListRepositoryInterface.swift
//  Reminder
//
//  Created by Vijaysudh M on 1/1/24.
//  
//

import Foundation

protocol CategoryListRepositoryInterface {
    associatedtype T
    func list() async throws -> [T]
    func get(_ id: UUID) async throws -> T?
    // func add(_ categoryList: T) async throws
    func add(_ categoryList: CategoryList) async throws
    func delete(_ id: UUID) async throws
    // func update(_ id: UUID, withUpdate categoryList: T) async throws
    func update(_ id: UUID, withUpdate categoryList: CategoryList) async throws
}
