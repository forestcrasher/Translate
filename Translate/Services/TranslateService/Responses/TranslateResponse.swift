//
//  TranslateResponse.swift
//  Translate
//
//  Created by Anton Pryakhin on 20.09.2020.
//

import Foundation

struct TranslateResponse: Decodable {

    let translations: [Translation]
}
