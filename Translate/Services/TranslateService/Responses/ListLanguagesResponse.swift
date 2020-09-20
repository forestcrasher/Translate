//
//  ListLanguagesResponse.swift
//  Translate
//
//  Created by Anton Pryakhin on 19.09.2020.
//

import Foundation

struct ListLanguagesResponse: Decodable {

    let languages: [Language]
}
