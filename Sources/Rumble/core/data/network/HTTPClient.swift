//
//  File.swift
//  
//
//  Created by 13402598 on 29/02/2024.
//

import Foundation
import Combine


public typealias Responseable = Decodable & Equatable
public typealias Requestable = Encodable


public enum HTTPHeadersInterceptor {
    case app(HTTPClient.HTTPHeaders)
    case single(HTTPClient.HTTPHeaders)
    case keys(HTTPClient.HTTPHeaders)
}

extension Encodable {
    
    public func encode() -> Data? {
        let encoder = JSONEncoder.init()
        guard let value = try? encoder.encode(self) else { return nil }
        return value
    }
}

public protocol HTTPClient {
    
    //typealias Result = Swift.Result<Responseable, Error>
    typealias HTTPHeaders = Dictionary<String, String>
    
    var headers: HTTPHeaders { get set }
    var headerInterceptor: HTTPHeadersInterceptor? { get set }
    var certificate: ISSLPinningCertificate? { get set }
    
    
    func get<Payload: Responseable>(from url: URL) async -> Swift.Result<Payload, Error>
    func post<T:Requestable, Payload: Responseable>(from url: URL, with data: T) async -> Swift.Result<Payload, Error>
    func put<T:Requestable, Payload: Responseable>(from url: URL, with data: T) async -> Swift.Result<Payload, Error>
    func delete<Payload: Responseable>(from url: URL) async -> Swift.Result<Payload, Error>
    
    func commit(type: HTTPHeadersInterceptor)
}
