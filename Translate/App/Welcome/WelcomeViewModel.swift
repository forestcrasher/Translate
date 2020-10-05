//
//  WelcomeViewModel.swift
//  Translate
//
//  Created by Anton Pryakhin on 05.09.2020.
//

import Foundation
import RxSwift
import RxCocoa

class WelcomeViewModel {

    // MARK: - Dependencies
    var coordinator: AppCoordinator!
    
    // MARK: - Input
    struct Input {
        
        let showTranslate: Signal<Void>
        let showHistory: Signal<Void>
    }
    
    // MARK: - Init
    init() {}

    // MARK: - Public
    func setup(with input: Input) {
        
        input.showTranslate
            .emit(onNext: { [unowned self] in
                self.coordinator.showTranslate()
            })
            .disposed(by: disposeBag)
        
        input.showHistory
            .emit(onNext: { [unowned self] in
                self.coordinator.showHistory()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private
    let disposeBag = DisposeBag()
}
