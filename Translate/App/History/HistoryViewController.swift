//
//  HistoryViewController.swift
//  Translate
//
//  Created by Anton Pryakhin on 06.09.2020.
//

import UIKit

class HistoryViewController: UIViewController {

    // MARK: - ViewModel
    weak var viewModel: HistoryViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "History"
        view.backgroundColor = UIColor.white
    }
}
