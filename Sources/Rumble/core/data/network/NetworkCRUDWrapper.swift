//
//  File.swift
//
//
//  Created by 13402598 on 05/02/2024.
//

import Foundation


@propertyWrapper public struct NetworkCRUDWrapper {
    var client: HTTPClient
    
    public var wrappedValue: any NetworkCRUD {
        mutating get {
            if let resource = Rumble.sdk.configuration?.sslResource, !resource.isEmpty {
                client.certificate = SSLPinningCertificate.init(forResource: resource)
            }
            
            let value = DefaultNetworkCRUD(client: client)
            return value
        }
    }
}
