//
//  File.swift
//
//
//  Created by 13402598 on 30/01/2024.
//

import Foundation


final class URLSessionHTTPClient : NSObject, HTTPClient {
    var headers: HTTPClient.HTTPHeaders = Rumble.sdk.configuration?.headers ?? .init()
    var certificate: ISSLPinningCertificate? = nil
    var headerInterceptor: HTTPHeadersInterceptor?
    
    private lazy var session : URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 1200
        let value = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        return value
    }()
    
    
    func get<Payload: Responseable>(from url: URL) async -> Swift.Result<Payload, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return await dataTask(request: request)
    }
    
    
    func delete<Payload: Responseable>(from url: URL) async -> Swift.Result<Payload, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        return await dataTask(request: request)
    }
    
    func post<T:Requestable, Payload: Responseable>(from url: URL, with data: T) async -> Swift.Result<Payload, Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data.encode()
        
        return await dataTask(request: request)
    }
    
    func put<T:Requestable, Payload: Responseable>(from url: URL, with data: T) async -> Swift.Result<Payload, Error> {
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = data.encode()
        
        return await dataTask(request: request)
    }
    
    func commit(type: HTTPHeadersInterceptor) {
        headerInterceptor = type
    }
}


private extension URLSessionHTTPClient {
    
    
    func dataTask<Payload: Responseable>(request: URLRequest) async -> Swift.Result<Payload, Error> {
        URLSessionHTTPClient.intercepHeaders(&headers, interceptor: &headerInterceptor)
        URLSessionHTTPClient.authorizationHeader(&headers, interceptor: headerInterceptor)
        
        print(request)
        
        var request = request
        self.setDefaultHeaders(&request)
        request.allHTTPHeaderFields = headers
        
        do {
            let result: (data: Data, response:URLResponse) = try await session.data(for: request)
            let object = try JSONDecoder().decode(Payload.self, from: result.data)
            
            let propertiesFilter = TokenFiltration(data: object)
            let tokens = propertiesFilter.parse()
            print("tokens count: \(tokens.count)")
            
            for accessToken in tokens {
                let token = Token.init(value: accessToken.token, key: accessToken.key)
                
                if let tokenData = token.encode() {
                    try KeychainInterface.save(sensitive: tokenData, account: token.key)
                }
            }
            
            print(object)
            return .success(object)
        } catch {
            return .failure(error)
        }
    }
}



extension  URLSessionHTTPClient: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        self.validateCertificate(didReceive: challenge) {
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        } cancel: {
            completionHandler(.cancelAuthenticationChallenge, nil)
        } mismatch: {
            completionHandler(.rejectProtectionSpace, nil)
        } `default`: {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
