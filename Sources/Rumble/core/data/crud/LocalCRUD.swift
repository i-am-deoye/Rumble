//
//  File.swift
//
//
//  Created by 13402598 on 13/02/2024.
//

import Foundation

public protocol LocalCRUD<Return> : LocalLoadable, LocalSaveable, LocalLoadableWithQuery, LocalUpdateable, LocalUpdateableWithQuery, LocalDeleteable, LocalDeleteableWithQuery {
    associatedtype Return
}
