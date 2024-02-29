//
//  File.swift
//  
//
//  Created by 13402598 on 26/02/2024.
//

import Foundation


public protocol SQLQuery: Query {}



public class DefaultSQLQuery: SQLQuery {
    public var value: String {
        return _query
    }
    
    
    private var _query:String = ""
    
    public init(){}
    
    
    @discardableResult public func equal(key:String, value:Any) -> Self {
        _query = _query + "\(key) == \(formatValue(value))"
        return self
    }
}

private extension DefaultSQLQuery {
    func formatValue(_ value: Any) -> String {
        return "\((value is String) ?  "'\(value)'" : "\(value)")"
    }
}
