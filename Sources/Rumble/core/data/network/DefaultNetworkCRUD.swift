//
//  File.swift
//
//
//  Created by 13402598 on 29/01/2024.
//

import Foundation



struct DefaultNetworkCRUD:NetworkCRUD {
    
    var client: HTTPClient

    
    func load<Return: Responseable>(url: URLString) async throws -> Return {
        guard let url = url.url else { throw CoreExceptions.urlFatalError }
        
        let result: Swift.Result<Return, Error> = await client.get(from: url)
        
        switch result {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    func save<Return: Responseable>(url: URLString, value: Requestable) async throws -> Return {
        guard let url = url.url else { throw CoreExceptions.urlFatalError }
        
        let result: Swift.Result<Return, Error> = await client.post(from: url, with: value)
        switch result {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    func load<Return: Responseable>(url: URLString, query: URLQuery) async throws -> Return {
        guard let url = (url + query.value).url else { throw CoreExceptions.urlFatalError }
        
        let result: Swift.Result<Return, Error> = await client.get(from: url)
        switch result {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    func update<Return: Responseable>(url: URLString, value: Requestable) async throws -> Return {
        guard let url = url.url else { throw CoreExceptions.urlFatalError }
        
        let result: Swift.Result<Return, Error> = await client.put(from: url, with: value)
        
        switch result {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    func update<Return: Responseable>(url: URLString, value: Requestable, query: URLQuery) async throws -> Return {
        guard let url = (url + query.value).url else { throw CoreExceptions.urlFatalError }
        
        let result: Swift.Result<Return, Error> = await client.put(from: url, with: value)
        
        switch result {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    func delete<Return: Responseable>(url: URLString, value: Requestable) async throws -> Return {
        guard let url = url.url else { throw CoreExceptions.urlFatalError }
        
        let result: Swift.Result<Return, Error> = await client.delete(from: url)
        
        switch result {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
    
    func delete<Return: Responseable>(url: URLString, query: URLQuery) async throws -> Return {
        guard let url = (url + query.value).url else { throw CoreExceptions.urlFatalError }
        
        let result: Swift.Result<Return, Error> = await client.delete(from: url)
        
        switch result {
        case .success(let success):
            return success
        case .failure(let failure):
            throw failure
        }
    }
}


