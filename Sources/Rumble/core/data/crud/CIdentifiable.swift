//
//  File.swift
//  
//
//  Created by 13402598 on 26/02/2024.
//

import Foundation

public protocol CIdentifiable<ID> where ID == any Hashable {
    associatedtype ID
}
