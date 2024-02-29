//
//  File.swift
//  
//
//  Created by 13402598 on 26/02/2024.
//

import Foundation

public protocol LocalDeleteable<Return>{
    associatedtype Return
    
    func delete(value: any Object) async throws -> Return
}


public protocol LocalDeleteableWithQuery<Return>{
    associatedtype Return
    
    func delete(query: SQLQuery) async throws -> Return
}


public protocol RemoteDeleteable{
    
    func delete<Return: Responseable>(url: URLString, value: any Requestable) async throws -> Return
}


public protocol RemoteDeleteableWithQuery{
    
    func delete<Return: Responseable>(url: URLString, query: URLQuery) async throws -> Return
}

