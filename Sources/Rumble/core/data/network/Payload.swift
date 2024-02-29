//
//  File.swift
//  
//
//  Created by 13402598 on 29/02/2024.
//

import Foundation

import Foundation


public struct Payload<R: Responseable>: Responseable {
    public var data: R
}
