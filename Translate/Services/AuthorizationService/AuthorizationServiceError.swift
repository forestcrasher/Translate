//
//  AuthorizationServiceError.swift
//  Translate
//
//  Created by Anton Pryakhin on 20.09.2020.
//

import Foundation

enum AuthorizationServiceError: Error {

    case dataNotLoaded
    case dataNotDecoded
    case networkNotAvailable

    var localizedDescription: String {
        switch self {
        case .dataNotLoaded:
            return "Data can't be loaded!"
        case .dataNotDecoded:
            return "Data can't be decoded!"
        case .networkNotAvailable:
            return "Network is not available!"
        }
    }
}
