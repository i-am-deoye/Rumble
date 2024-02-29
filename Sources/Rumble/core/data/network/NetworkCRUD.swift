//
//  File.swift
//  
//
//  Created by 13402598 on 29/02/2024.
//

import Foundation

public protocol NetworkCRUD: RemoteCRUD {
    
    var client: HTTPClient { get set }
}
