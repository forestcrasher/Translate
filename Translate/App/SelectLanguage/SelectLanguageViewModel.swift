//
//  SelectLanguageViewModel.swift
//  Translate
//
//  Created by Anton Pryakhin on 30.09.2020.
//

import Foundation
import RxSwift
import RxCocoa

class SelectLanguageViewModel {
    
    // MARK: - Dependencies
    private let coordinator: TranslateCoordinator?
    
    // MARK: - Init
    init(coordinator: TranslateCoordinator, languages: [Language], currentLanguage: Language?, languageType: LanguageType) {
        self.coordinator = coordinator
        self.languages.accept(languages)
        self.currentLanguage.accept(currentLanguage)
        self.languageType.accept(languageType)
    }
    
    // MARK: - Public
    var languages = BehaviorRelay<[Language]>(value: [])
    var currentLanguage = BehaviorRelay<Language?>(value: nil)
    var languageType = BehaviorRelay<LanguageType>(value: .source)
    
    enum LanguageType {
        
        case source
        case target
    }
    
    func selectLanguage(language: Language) {
        switch languageType.value {
        case .source:
            coordinator?.hideSelectionSourceLanguage(selectedLanguage: language)
        case .target:
            coordinator?.hideSelectionTargetLanguage(selectedLanguage: language)
        }
    }
    
    func close() {
        coordinator?.hideSelectionLanguage()
    }
}
