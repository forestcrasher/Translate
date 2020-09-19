//
//  TranslateViewModel.swift
//  Translate
//
//  Created by Anton Pryakhin on 06.09.2020.
//

import Foundation
import Swinject

class TranslateViewModel {

    // MARK: - Dependencies
    let translateService: TranslateService?
    let historyService: HistoryService?
    let coordinator: TranslateCoordinator?

    init(container: Container, coordinator: TranslateCoordinator) {
        self.translateService = container.resolve(TranslateService.self)
        self.historyService = container.resolve(HistoryService.self)
        self.coordinator = coordinator

        setup()
    }

    func setup() {
        translateService?.listLanguages().subscribe(onNext: { languages in
            print(languages)
        }, onError: { error in
            if let error = error as? TranslateServiceError {
                print(error.localizedDescription)
            }
        })
    }
}
