//
//  File.swift
//  
//
//  Created by 13402598 on 29/02/2024.
//

import Foundation

open class BaseUsecase {
    @NetworkCRUDWrapper(client: URLSessionHTTPClient()) public var network
    
    public required init() {}
    
    func commit(type: HTTPHeadersInterceptor) {  }
}

