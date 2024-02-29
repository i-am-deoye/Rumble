//
//  File.swift
//
//
//  Created by 13402598 on 05/02/2024.
//

import Foundation

struct EmptyData: Responseable {
    static func isEmpty(value: any Responseable) -> Bool {
        return type(of: value) is EmptyData.Type
    }
}
