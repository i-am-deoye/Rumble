//
//  File.swift
//  
//
//  Created by 13402598 on 29/02/2024.
//

import Foundation


public protocol LocalSaveable<Return> {
    associatedtype Return
    
    func save(value: any Object) async throws -> Return
}


public protocol RemoteSaveable {
    
    func save<Return: Responseable>(url: URLString, value: any Requestable) async throws -> Return
}

