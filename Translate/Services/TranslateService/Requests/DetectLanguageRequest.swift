//
//  DetectLanguageRequest.swift
//  Translate
//
//  Created by Anton Pryakhin on 20.09.2020.
//

import Foundation

struct DetectLanguageRequest: Encodable {

    let text: String
    let languageCodeHints: [String]?
    let folderId: String?
}
