//
//  File.swift
//
//
//  Created by 13402598 on 30/01/2024.
//

import Foundation


public class KeychainInterface {
    static let service: String = Bundle.main.bundleIdentifier ?? ""
    static var authenticatedKey: String = Rumble.sdk.configuration?.authenticatedKey ?? ""
    static private let cache = UserDefaults.standard
    static private var cacheKey = "cache-keys"
    
    public enum KeychainError: Error {
        case itemNotFound
        
        case duplicateItem
        
        case invalidItemFormat
        
        case unexpectedStatus(OSStatus)
    }
    
    public static var authenticated: Bool {
        guard let token: Token = try? readPassword(account: authenticatedKey) else { return false }
        return !token.value.isEmpty
    }
    
    public static func reset() {
        keys().forEach { key in
            try? deletePassword(account: key)
        }
    }
    
    private static func keys() -> [String] {
        return cache.array(forKey: cacheKey) as? [String] ?? []
    }
    
    private static func add(key: String) {
        var keys = keys()
        keys.append(key)
        
        cache.set(keys, forKey: cacheKey)
        cache.synchronize()
    }
    
    private static func remove(key: String) {
        var keys = keys()
        keys.removeAll(where: { key == $0 })
        
        cache.set(keys, forKey: cacheKey)
        cache.synchronize()
    }
    
    private static func contain(key: String) -> Bool {
        return keys().contains(key)
    }
}


extension KeychainInterface {
    public static func save(sensitive: Data, account: String) throws {
        
        if contain(key: account) {
            try update(sensitive: sensitive, account: account)
            return
        }

        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            
            kSecValueData as String: sensitive as AnyObject
        ]
        
        let status = SecItemAdd(
            query as CFDictionary,
            nil
        )
        
        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
        }

        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
        
        add(key: account)
    }
    
    public static func update(sensitive: Data, account: String) throws {
        
        if !contain(key: account) {
            try save(sensitive: sensitive, account: account)
            return
        }
        
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]
        
        let attributes: [String: AnyObject] = [
            kSecValueData as String: sensitive as AnyObject
        ]
        
        let status = SecItemUpdate(
            query as CFDictionary,
            attributes as CFDictionary
        )

        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }

        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
        
        add(key: account)
    }
    
    public static func readPassword<T:Decodable>(account: String) throws -> T {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword,
            
            kSecMatchLimit as String: kSecMatchLimitOne,

            kSecReturnData as String: kCFBooleanTrue
        ]

        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &itemCopy
        )

        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }

        guard let data = itemCopy as? Data else {
            throw KeychainError.invalidItemFormat
        }
        
        do {
            let sensitive = try JSONDecoder().decode(T.self, from: data)
            return sensitive
        } catch {
            throw KeychainError.invalidItemFormat
        }
    }
    
    public static func readPasswords<T:Decodable>() throws -> [T] {
        let items: [T] = keys().compactMap({ key in try? readPassword(account: key) })
        return items
    }
    
    public static func deletePassword(account: String) throws {
        let query: [String: AnyObject] = [
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecClass as String: kSecClassGenericPassword
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
        
        remove(key: account)
    }
}
