//
//  WelcomeViewController.swift
//  Translate
//
//  Created by Anton Pryakhin on 05.09.2020.
//

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - ViewModel
    var viewModel: WelcomeViewModel!

    // MARK: - Actions
    @IBAction private func touchTranslateButton() {
        self.viewModel.showTranslate()
    }

    @IBAction func touchHistoryButton() {
        viewModel.showHistory()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
