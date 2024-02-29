//
//  File.swift
//  
//
//  Created by 13402598 on 26/02/2024.
//

import Foundation


public protocol URLQuery: Query {}

public struct DefaultURLQuery: URLQuery {
    public var value: String {
        return url
    }
    
    
    private var url:String
    private var isUrlEmpty: Bool
    
    
    public init(url: String = ""){
        self.url = url
        self.isUrlEmpty = url.isEmpty
    }
}


public extension DefaultURLQuery {
    
    @discardableResult mutating func path(key: String, value: String) throws -> Self {
        if isUrlEmpty {
            url = url + "\\" + "\(value)"
        } else {
            url = url.replacingOccurrences(of: key, with: value)
        }
        return self
    }
    
    @discardableResult mutating func query(key: String, value: String) throws -> Self {
        let hasQuery = url.contains("=")
        
        if hasQuery {
            url = url + "&\(key)=\(value)"
        } else {
            url = "?\(key)=\(value)"
        }
        return self
    }
}
