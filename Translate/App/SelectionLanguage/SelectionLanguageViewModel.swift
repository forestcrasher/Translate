//
//  SelectionLanguageViewModel.swift
//  Translate
//
//  Created by Anton Pryakhin on 30.09.2020.
//

import Foundation
import RxSwift
import RxCocoa

class SelectionLanguageViewModel {
    
    // MARK: - Dependencies
    var coordinator: TranslateCoordinator!
    
    // MARK: - Input
    struct Input {
        
        let selectLanguage: Signal<Language>
        let close: Signal<Void>
    }
    
    // MARK: - Init
    init(languages: [Language], currentLanguage: Language?, languageType: LanguageType) {
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
    
    func setup(with input: Input) {
    
        input.selectLanguage
            .emit(onNext: { [unowned self] in
                switch self.languageType.value {
                case .source:
                    self.coordinator.hideSelectionSourceLanguage(selectedLanguage: $0)
                case .target:
                    self.coordinator.hideSelectionTargetLanguage(selectedLanguage: $0)
                }
            })
            .disposed(by: disposeBag)
        
        input.close
            .emit(onNext: { [unowned self] in
                self.coordinator.hideSelectionLanguage()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private
    private let disposeBag = DisposeBag()
}
