//
//  File.swift
//  
//
//  Created by 13402598 on 29/02/2024.
//

import Foundation

public protocol Searchable {}

public protocol Tokenizable: TokenizableKey {
    var token: String { get }
}

public protocol TokenizableKey {
    var key: String { get set }
}

public struct Token: Responseable, Requestable, TokenizableKey {
    public var value: String
    public var key: String
    
    init(value: String, key: String) {
        self.value = value
        self.key = key
    }
}

