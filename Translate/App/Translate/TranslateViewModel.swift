//
//  TranslateViewModel.swift
//  Translate
//
//  Created by Anton Pryakhin on 06.09.2020.
//

import Foundation
import RxSwift

import Swinject

class TranslateViewModel {

    // MARK: - Dependencies
    private let translateService: TranslateService?
    private let historyService: HistoryService?
    private let coordinator: TranslateCoordinator?

    // MARK: - Init
    init(container: Container, coordinator: TranslateCoordinator) {
        self.translateService = container.resolve(TranslateService.self)
        self.historyService = container.resolve(HistoryService.self)
        self.coordinator = coordinator

        setup()
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()

    private func setup() {
        translateService?.listLanguages()?
            .subscribe(onNext: { languages in
                print(languages)
            }, onError: { error in
                if let error = error as? TranslateServiceError {
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)

        translateService?.detectLanguage(text: "Hello")?
            .subscribe(onNext: { languageCode in
                print(languageCode)
            }, onError: { error in
                if let error = error as? TranslateServiceError {
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)

        translateService?.translate(sourceLanguageCode: "en", targetLanguageCode: "ru", text: "Hello")?
            .subscribe(onNext: { translations in
                if let translation = translations.first {
                    print(translation)
                }
            }, onError: { error in
                if let error = error as? TranslateServiceError {
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
}
