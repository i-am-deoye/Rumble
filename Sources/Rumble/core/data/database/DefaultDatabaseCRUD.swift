//
//  File.swift
//
//
//  Created by 13402598 on 13/02/2024.
//

import Foundation


struct DefaultDatabaseCRUD<T: Value>:DatabaseCRUD {
    
    typealias Return = SQLResult
    
    var driver: IDataBaseDriver
    

    func load() async throws -> any SQLResult {
        return await driver.fetch(T.self)
    }
    
    func save(value: any Value) async throws -> any SQLResult {
        return await driver.save(value)
    }
    
    func load(query: SQLQuery) async throws -> any SQLResult {
        return await driver.fetch(T.self, query: query )
    }
    
    func update(value: any Value, query: SQLQuery) async throws -> any SQLResult {
        return await driver.update(value, query: query)
    }
    
    func update(value: any Value) async throws -> any SQLResult {
        return await driver.save(value)
    }
    
    func delete(value: any Value) async throws -> any SQLResult {
        return await driver.delete(value)
    }
    
    func delete(query: SQLQuery) async throws -> any SQLResult {
        return await driver.delete(T.self, query: query)
    }
}
