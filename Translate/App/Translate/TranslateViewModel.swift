//
//  TranslateViewModel.swift
//  Translate
//
//  Created by Anton Pryakhin on 06.09.2020.
//

import Foundation

class TranslateViewModel {

    // MARK: - Dependencies
    weak var translateService: TranslateService!
    weak var historyService: HistoryService!
    weak var coordinator: TranslateCoordinator!
}
