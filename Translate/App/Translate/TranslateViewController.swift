//
//  TranslateViewController.swift
//  Translate
//
//  Created by Anton Pryakhin on 06.09.2020.
//

import Cartography
import UIKit

class TranslateViewController: UIViewController {

    // MARK: - ViewModel
    var viewModel: TranslateViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Translate"
        view.backgroundColor = .systemBackground

        let translateFromButton = UIButton()
        translateFromButton.setTitle("Russian", for: .normal)
        translateFromButton.setTitleColor(Color.normal, for: .normal)
        translateFromButton.setTitleColor(Color.highlighted, for: .highlighted)
        translateFromButton.contentHorizontalAlignment = .center

        let translateToButton = UIButton()
        translateToButton.setTitle("English", for: .normal)
        translateToButton.setTitleColor(Color.normal, for: .normal)
        translateToButton.setTitleColor(Color.highlighted, for: .highlighted)
        translateToButton.contentHorizontalAlignment = .center

        let toggleLanguageButton = UIButton()
        let toggleLanguageButtonImage = UIImage(systemName: "arrow.right.arrow.left")
        toggleLanguageButton.setImage(toggleLanguageButtonImage?.withTintColor(Color.normal), for: .normal)
        toggleLanguageButton.setImage(toggleLanguageButtonImage?.withTintColor(Color.highlighted, renderingMode: .alwaysOriginal), for: .highlighted)

        let topButtons = UIStackView(arrangedSubviews: [translateFromButton, toggleLanguageButton, translateToButton])
        topButtons.axis = .horizontal
        topButtons.spacing = 0.0
        topButtons.alignment = .center
        topButtons.distribution = .fillEqually
        topButtons.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topButtons)

        constrain(topButtons, view) { topButtons, view in
            topButtons.top == view.safeAreaLayoutGuide.top
            topButtons.left == view.left + 16.0
            topButtons.right == view.right - 16.0
            topButtons.height == 44.0
        }

        let topButtonsSeparator = UIView()
        topButtonsSeparator.backgroundColor = .separator
        topButtonsSeparator.translatesAutoresizingMaskIntoConstraints = false
        topButtons.addSubview(topButtonsSeparator)

        constrain(topButtonsSeparator, topButtons) { topButtonsSeparator, topButtons in
            topButtonsSeparator.bottom == topButtons.bottom
            topButtonsSeparator.left == topButtons.left - 16.0
            topButtonsSeparator.right == topButtons.right + 16.0
            topButtonsSeparator.height == 0.5
        }
    }

    private enum Color {

        static let normal = UIColor.systemBlue
        static let highlighted = normal.withAlphaComponent(0.3)
    }
}
