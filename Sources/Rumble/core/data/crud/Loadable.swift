//
//  Loadable.swift
//
//
//  Created by 13402598 on 29/01/2024.
//

import Foundation


public protocol LocalLoadable<Return>{
    associatedtype Return
    
    func load() async throws -> Return
}


public protocol LocalLoadableWithQuery<Return>{
    associatedtype Return
    
    func load(query: SQLQuery) async throws -> Return
}


public protocol RemoteLoadable{
    
    func load<Return: Responseable>(url: URLString) async throws -> Return
}


public protocol RemoteLoadableWithQuery{
    
    func load<Return: Responseable>(url: URLString, query: URLQuery) async throws -> Return
}
