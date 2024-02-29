//
//  File.swift
//  
//
//  Created by 13402598 on 29/02/2024.
//

import Foundation

public protocol SQLResult<T> {
    associatedtype T
    
    var error: String? { get set }
    var value: T? { get set }
}


public struct Fetched<T>: SQLResult {
    public var value: T?
    public var error: String?
    
    public init(value: T? = nil, error: String? = nil) {
        self.value = value
        self.error = error
    }
}


public struct Saved:SQLResult {
    public typealias T = Bool
    
    public var value: Bool?
    public var error: String?
    
    public init(value: Bool? = nil, error: String? = nil) {
        self.value = value
        self.error = error
    }
}

public struct Deleted: SQLResult {
    public typealias T = Bool
    
    public var value: Bool?
    public var error: String?
    
    public init(value: Bool? = nil, error: String? = nil) {
        self.value = value
        self.error = error
    }
}
