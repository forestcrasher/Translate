//
//  WelcomeViewModel.swift
//  Translate
//
//  Created by Anton Pryakhin on 05.09.2020.
//

import Foundation

class WelcomeViewModel {

    // MARK: - Dependencies
    var coordinator: AppCoordinator!

    // MARK: - Public
    func showTranslate() {
        coordinator.showTabBar(selectedTab: .translate)
    }

    func showHistory() {
        coordinator.showTabBar(selectedTab: .history)
    }
}
