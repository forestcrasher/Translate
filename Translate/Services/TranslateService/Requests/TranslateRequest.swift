//
//  TranslateRequest.swift
//  Translate
//
//  Created by Anton Pryakhin on 20.09.2020.
//

import Foundation

struct TranslateRequest: Encodable {

    let sourceLanguageCode: String
    let targetLanguageCode: String
    let format: String
    let texts: [String]
    let folderId: String?
}
