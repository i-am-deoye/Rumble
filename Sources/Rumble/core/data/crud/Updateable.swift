//
//  File.swift
//  
//
//  Created by 13402598 on 29/02/2024.
//

import Foundation



public protocol LocalUpdateable<Return>{
    associatedtype Return
    
    func update(value: any Object) async throws -> Return
}


public protocol LocalUpdateableWithQuery<Return>{
    associatedtype Return
    
    func update(value: any Object, query: SQLQuery) async throws -> Return
}


public protocol RemoteUpdateable {
    func update<Return: Responseable>(url: URLString, value: any Requestable) async throws -> Return
}


public protocol RemoteUpdateableWithQuery{
    func update<Return: Responseable>(url: URLString, value: any Requestable, query: URLQuery) async throws -> Return
}

