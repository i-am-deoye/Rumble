//
//  File.swift
//  
//
//  Created by 13402598 on 29/02/2024.
//

import Foundation

public protocol IDataBaseDriver {
    
    @discardableResult func save<T>(_ entity: T) async -> Saved
    @discardableResult func save<T>(_ entities: [T]) async -> Saved
    @discardableResult func update<T>(_ entity: T, query: SQLQuery) async -> Saved
    @discardableResult func fetch<T>(_ type: T.Type, query: SQLQuery) async -> Fetched<[T]>
    @discardableResult func fetch<T>(_ type: T.Type) async -> Fetched<[T]>
    @discardableResult func delete<T>(_ entity: T) async -> Deleted
    @discardableResult func delete<T>(_ type: T.Type, query: SQLQuery) async -> Deleted
}
