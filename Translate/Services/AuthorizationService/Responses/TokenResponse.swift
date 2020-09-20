//
//  TokenResponse.swift
//  Translate
//
//  Created by Anton Pryakhin on 20.09.2020.
//

import Foundation

struct TokenResponse: Decodable {

    let iamToken: String
    let expiresAt: Date
}
