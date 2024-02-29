//
//  File.swift
//  
//
//  Created by 13402598 on 29/02/2024.
//

import Foundation

public protocol ISSLPinningCertificate {
    var forResource: String { get }
    
    init(forResource: String)
    func validate(value: Data) -> Bool
}


public class SSLPinningCertificate: ISSLPinningCertificate {
    public var forResource: String
    
    private lazy var certificates: [Data] = {
        let url = Bundle.main.url(forResource: forResource, withExtension: "cer")!
        let data = try! Data(contentsOf: url)
        return [data]
      }()
    
    
    required public init(forResource: String) {
        self.forResource = forResource
    }
    
    public func validate(value: Data) -> Bool {
        return certificates.contains(value)
    }
}
