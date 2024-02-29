//
//  File.swift
//  
//
//  Created by 13402598 on 29/02/2024.
//

import Foundation

public enum CoreExceptions: Error {
    case urlFatalError
    case queryFatalError
    
    
    public var get: String {
        switch self {
        case .urlFatalError: return "url found to be null, please check."
        case .queryFatalError: return "query found to be null, please check."
        }
    }
}
