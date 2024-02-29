//
//  File.swift
//  
//
//  Created by 13402598 on 26/02/2024.
//

import Foundation


public protocol RemoteCRUD: RemoteLoadable, RemoteSaveable, RemoteLoadableWithQuery, RemoteUpdateable, RemoteUpdateableWithQuery, RemoteDeleteable, RemoteDeleteableWithQuery {
}
