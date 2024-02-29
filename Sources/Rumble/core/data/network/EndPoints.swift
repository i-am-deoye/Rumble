//
//  File.swift
//  
//
//  Created by 13402598 on 29/02/2024.
//

import Foundation

public typealias URLString = String

public protocol EndPoints {
    var rawvalue: String { get }
    func base() -> String
}


extension EndPoints {

    public var absoluteString: String {
        return base()+rawvalue
    }
    
    public var url: URL {
        guard let url = absoluteString.url else {
            preconditionFailure("The url used in \(EndPoints.self) is not valid")
        }
        return url
    }
}

extension String {
    public var url: URL? {
        return URL(string: self.replacingOccurrences(of: " ", with: "%20"))
    }
}
