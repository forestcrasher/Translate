//
//  Language.swift
//  Translate
//
//  Created by Anton Pryakhin on 19.09.2020.
//

import Foundation

struct Language: Decodable {

    let code: String
    let name: String?
}

extension Language: Equatable {
    
    static func == (lhs: Language, rhs: Language) -> Bool {
        return lhs.code == rhs.code
    }
}
