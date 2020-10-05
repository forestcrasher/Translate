//
//  WelcomeViewController.swift
//  Translate
//
//  Created by Anton Pryakhin on 05.09.2020.
//

import UIKit
import RxSwift
import RxCocoa

class WelcomeViewController: UIViewController {

    // MARK: - ViewModel
    var viewModel: WelcomeViewModel!

    // MARK: - Outlets
    @IBOutlet private weak var translateButton: ShapeButton!
    @IBOutlet private weak var historyButton: ShapeButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBindings()
    }
    
    // MARK: - Private
    
    private func setupBindings() {
        
        setupViewModel()
    }
    
    private func setupViewModel() {
        
        viewModel.setup(with: WelcomeViewModel.Input(
            showTranslate: translateButton.rx.tap.asSignal(),
            showHistory: historyButton.rx.tap.asSignal()
        ))
    }
}
