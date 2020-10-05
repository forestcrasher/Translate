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
    var translateService: TranslateService!
    var historyService: HistoryService!
    var coordinator: TranslateCoordinator!

    // MARK: - Input
    struct Input {
        
        let showSelectionSourceLanguage: Signal<Void>
        let showSelectionTargetLanguage: Signal<Void>
        let toggleLanguage: Signal<Void>
        let sourceText: Driver<String>
    }
    
    // MARK: - Init
    init() {}
    
    // MARK: - Public
    let sourceLanguages = BehaviorRelay<[Language]>(value: [])
    let targetLanguages = BehaviorRelay<[Language]>(value: [])
    let currentSourceLanguage = BehaviorRelay<Language?>(value: nil)
    let currentTargetLanguage = BehaviorRelay<Language?>(value: nil)
    let sourceText = BehaviorRelay<String>(value: "")
    let targetText = BehaviorRelay<String>(value: "")
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    func setup(with input: Input) {
        
        loadLanguages()
        
        input.showSelectionSourceLanguage
            .emit(onNext: { [unowned self] in
                self.coordinator?.showSelectionSourceLanguage(languages: self.sourceLanguages.value, currentLanguage: self.currentSourceLanguage.value)
            })
            .disposed(by: disposeBag)
        
        input.showSelectionTargetLanguage
            .emit(onNext: { [unowned self] in
                self.coordinator?.showSelectionTargetLanguage(languages: self.targetLanguages.value, currentLanguage: self.currentTargetLanguage.value)
            })
            .disposed(by: disposeBag)

        input.toggleLanguage
            .emit(onNext: { [unowned self] in
                self.toggleLanguage()
            })
            .disposed(by: disposeBag)
        
        input.sourceText
            .asObservable()
            .bind(to: self.sourceText)
            .disposed(by: disposeBag)
        
        Observable
            .combineLatest(
                self.sourceText.asObservable(),
                self.currentSourceLanguage.asObservable(),
                self.currentTargetLanguage.asObservable()
            )
            .debounce(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .flatMap { [unowned self] sourceText, currentLanguageFrom, currentLanguageTo -> Observable<[Translation]> in
                self.isLoading.accept(true)
                return !sourceText.isEmpty && sourceText != "Enter text⁣"
                    ? (self.translateService?.translate(sourceLanguageCode: currentLanguageFrom?.code ?? "", targetLanguageCode: currentLanguageTo?.code ?? "", text: sourceText))!
                    : Observable.just([emptyTranslation])
            }
            .subscribe(onNext: { [unowned self] in
                if let detectedLanguageCode = $0.first?.detectedLanguageCode {
                    if let detectedLanguage = sourceLanguages.value.first(where: { $0.code == detectedLanguageCode }) {
                        currentSourceLanguage.accept(detectedLanguage)
                    }
                }
                self.targetText.accept($0.first?.text ?? "")
                self.isLoading.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func setCurrentSourceLanguage(language: Language) {
        
        if language == currentTargetLanguage.value, currentSourceLanguage.value != automaticLanguage {
            toggleLanguage()
        } else {
            currentSourceLanguage.accept(language)
        }
    }
    
    func setCurrentTargetLanguage(language: Language) {
        
        if language == currentSourceLanguage.value {
            toggleLanguage()
        } else {
            currentTargetLanguage.accept(language)
        }
    }

    // MARK: - Private
    private let disposeBag = DisposeBag()
    
    private let automaticLanguage = Language(code: "", name: "Automatic")
    private let engishLanguage = Language(code: "en", name: "English")
    private let emptyTranslation = Translation(text: "", detectedLanguageCode: nil)
    
    private func toggleLanguage() {
        
        let tempLanuguage = currentSourceLanguage.value
        currentSourceLanguage.accept(currentTargetLanguage.value)
        currentTargetLanguage.accept(tempLanuguage)
        
        sourceText.accept(targetText.value)
        targetText.accept("")
    }
    
    private func loadLanguages() {
        
        translateService?.listLanguages()?
            .subscribe(onNext: { [unowned self] languages in
                let filteredLanguages = languages.filter { !($0.name?.isEmpty ?? true) }
                let languagesWithAutomatic = [self.automaticLanguage] + filteredLanguages
                self.sourceLanguages.accept(languagesWithAutomatic)
                self.targetLanguages.accept(filteredLanguages)
                self.currentSourceLanguage.accept(self.automaticLanguage)
                self.currentTargetLanguage.accept(self.engishLanguage)
            }, onError: { error in
                if let error = error as? TranslateServiceError {
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
    }
}
