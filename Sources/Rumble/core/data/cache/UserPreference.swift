//
//  File.swift
//  
//
//  Created by 13402598 on 29/02/2024.
//

import Foundation

@propertyWrapper public struct UserDefaultsLiteral<Value: Hashable> {
    public let key: CachingKeys
    public var storage: UserDefaults = .standard
    
    public init(key: CachingKeys, storage: UserDefaults = .standard) {
        self.key = key
        self.storage = storage
    }

    public var wrappedValue: Value? {
        get { storage.value(forKey: key.get) as? Value }
        set { storage.setValue(newValue, forKey: key.get) }
    }
}

@propertyWrapper public struct UserDefaultsObject<Value:Codable> {
    public let key: CachingKeys
    public var storage: UserDefaults = .standard
    
    public init(key: CachingKeys, storage: UserDefaults = .standard) {
        self.key = key
        self.storage = storage
    }

    public var wrappedValue: Value? {
        
        get {
            guard let result = storage.value(forKey: key.get) as? Data else { return nil }
            return try? JSONDecoder().decode(Value.self, from: result)
        }
        
        set {
            guard let jsonData = try? JSONEncoder().encode(newValue) else { return }
            storage.set(jsonData, forKey: key.get)
        }
    }
}


public protocol CachingKeys {
    var get: String { get }
}
