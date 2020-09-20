//
//  Translation.swift
//  Translate
//
//  Created by Anton Pryakhin on 20.09.2020.
//

import Foundation

struct Translation: Decodable {
    let text: String?
    let detectedLanguageCode: String?
}
