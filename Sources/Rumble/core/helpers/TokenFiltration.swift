//
//  TokenFileter.swift
//
//
//  Created by 13402598 on 29/02/2024.
//

import Foundation


final class TokenFiltration<D: Decodable> {
    private let data: D
    private var items = [Any]()
    
    
    init(data: D) {
        self.data = data
    }
    
    
    
    @discardableResult func parse() -> [Tokenizable] {
        mirror(any: data)
        return items.compactMap({ $0 as? Tokenizable })
    }
    

    private func mirror(any: Any) {
        let mirror = Mirror(reflecting: any)
        if let value = mirror.subjectType as? Tokenizable {
            appendIfAvailable(value)
        }
        
        search(mirrorInstance: mirror)
    }
    
    private func appendIfAvailable(_ value: Tokenizable?) {
        guard let object = value else { return }
        items.append(object)
    }
    
    private func search(mirrorInstance: Mirror) {
        
        for child in mirrorInstance.children {
            if let value = child.value as? Tokenizable {
                appendIfAvailable(value)
            } else if (child.value is Searchable) {
                mirror(any: child.value)
            }
        }
    }
}
