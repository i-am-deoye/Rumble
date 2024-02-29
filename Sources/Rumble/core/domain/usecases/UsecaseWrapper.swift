//
//  File.swift
//  
//
//  Created by 13402598 on 29/02/2024.
//

import Foundation


@propertyWrapper public struct UsecaseWrapper<Usecase: BaseUsecase> {
    public init() {}
    
    public var wrappedValue:  Usecase {
        get {
            let value = Usecase()
            return value
        }
    }
}
