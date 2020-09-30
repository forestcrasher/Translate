//
//  TranslateViewModel.swift
//  Translate
//
//  Created by Anton Pryakhin on 06.09.2020.
//

import Foundation
import RxSwift
import RxCocoa
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

        loadLanguages()
    }
    
    // MARK: - Public
    let languagesFrom = BehaviorRelay<[Language]>(value: [])
    let languagesTo = BehaviorRelay<[Language]>(value: [])
    let currentLanguageFrom = BehaviorRelay<Language?>(value: nil)
    let currentLanguageTo = BehaviorRelay<Language?>(value: nil)
    let translateText = BehaviorRelay<String>(value: "")
    
    func showSelectionLanguageFrom() {
        coordinator?.showSelectionLanguageFrom(languages: languagesFrom.value, currentLanguage: currentLanguageFrom.value)
    }
    
    func showSelectionLanguageTo() {
        coordinator?.showSelectionLanguageTo(languages: languagesTo.value, currentLanguage: currentLanguageTo.value)
    }
    
    func toggleLanguage() {
        let temp = currentLanguageFrom.value
        currentLanguageFrom.accept(currentLanguageTo.value)
        currentLanguageTo.accept(temp)
    }
    
    func setCurrentLanguageFrom(language: Language) {
        if language == currentLanguageTo.value, currentLanguageFrom.value != automaticLanguage {
            toggleLanguage()
        } else {
            currentLanguageFrom.accept(language)
        }
    }
    
    func setCurrentLanguageTo(language: Language) {
        if language == currentLanguageFrom.value {
            toggleLanguage()
        } else {
            currentLanguageTo.accept(language)
        }
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()
    
    private let automaticLanguage = Language(code: "", name: "Automatic")
    private let engishLanguage = Language(code: "en", name: "English")

    private func setup() {
//        translateService?.detectLanguage(text: "Hello")?
//            .subscribe(onNext: { languageCode in
//                print(languageCode)
//            }, onError: { error in
//                if let error = error as? TranslateServiceError {
//                    print(error.localizedDescription)
//                }
//            })
//            .disposed(by: disposeBag)
//
//        translateService?.translate(sourceLanguageCode: "en", targetLanguageCode: "ru", text: "Hello")?
//            .subscribe(onNext: { translations in
//                if let translation = translations.first {
//                    print(translation)
//                }
//            }, onError: { error in
//                if let error = error as? TranslateServiceError {
//                    print(error.localizedDescription)
//                }
//            })
//            .disposed(by: disposeBag)
    }
    
    private func loadLanguages() {
        translateService?.listLanguages()?
            .subscribe(onNext: { [unowned self] languages in
                let filteredLanguages = languages.filter { !($0.name?.isEmpty ?? true) }
                let languagesWithAutomatic = [self.automaticLanguage] + filteredLanguages
                
                self.languagesFrom.accept(languagesWithAutomatic)
                self.languagesTo.accept(filteredLanguages)
                
                self.currentLanguageFrom.accept(self.automaticLanguage)
                self.currentLanguageTo.accept(self.engishLanguage)
            }, onError: { error in
                if let error = error as? TranslateServiceError {
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
}
