//
//  TranslateViewController.swift
//  Translate
//
//  Created by Anton Pryakhin on 06.09.2020.
//

import UIKit

class TranslateViewController: UIViewController {

    // MARK: - ViewModel
    var viewModel: TranslateViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Translate"
        view.backgroundColor = UIColor.white
    }
}
