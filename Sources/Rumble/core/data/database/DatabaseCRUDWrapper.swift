//
//  File.swift
//
//
//  Created by 13402598 on 05/02/2024.
//

import Foundation



@propertyWrapper public struct DatabaseCRUDWrapper<D:Value> {
    let local: IDataBaseDriver
    
    public init(local: IDataBaseDriver = CoreDataDriver.shared) {
        self.local = local
    }
    
    public var wrappedValue: any DatabaseCRUD {
        get {
            let value = DefaultDatabaseCRUD<D>(driver: local)
            return value
        }
    }
}
