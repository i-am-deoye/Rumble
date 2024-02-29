//
//  File.swift
//
//
//  Created by 13402598 on 13/02/2024.
//

import Foundation


extension HTTPClient {
    func setDefaultHeaders(_ request:inout URLRequest) {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    }

    static func authorizationHeader(_ headers:inout HTTPHeaders, interceptor: HTTPHeadersInterceptor?) {
        if let headerInterceptor = interceptor {
            switch headerInterceptor {
            case .single( _): return
                default: break
            }
        }
        

        guard let tokens: [Token] = try? KeychainInterface.readPasswords() else { return }
        
        tokens.forEach { token in
            headers[token.key] = token.value
        }
    }
    
    static func intercepHeaders(_ headers: inout HTTPHeaders, interceptor: inout HTTPHeadersInterceptor?) {
        guard let headerInterceptor = interceptor else { return }
        var appHeaders = Rumble.sdk.configuration?.headers ?? .init()
        
        switch headerInterceptor {
        case .app(let hTTPHeaders):
            headers = hTTPHeaders
        case .single(let hTTPHeaders):
            interceptor = .app(appHeaders)
            headers = hTTPHeaders
        case .keys(let hTTPHeaders):
            hTTPHeaders.forEach { item in
                appHeaders[item.key] = item.value
            }
            headers = appHeaders
            interceptor = .app(headers)
        }
    }
    
    func validateCertificate(didReceive challenge: URLAuthenticationChallenge,
                             success: @escaping () -> Void,
                             cancel: @escaping () -> Void,
                             mismatch: @escaping () -> Void,
                             `default`: @escaping () -> Void) {
        
        guard let ssl = certificate else {
            `default`()
            return
        }
        
        if let trust = challenge.protectionSpace.serverTrust,
           SecTrustGetCertificateCount(trust) > 0 {
            if let certificate = SecTrustGetCertificateAtIndex(trust, 0) {
                let data = SecCertificateCopyData(certificate) as Data
                if ssl.validate(value: data) {
                    success()
                    return
                } else {
                    mismatch()
                }
            }
            
        }
        cancel()
    }
}

