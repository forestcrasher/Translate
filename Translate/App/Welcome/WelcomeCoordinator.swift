//
//  WelcomeCoordinator.swift
//  Translate
//
//  Created by Anton Pryakhin on 06.09.2020.
//

import Swinject
import UIKit

class WelcomeCoordinator: Coordinator {

    // MARK: - Public
    var navigationController: UINavigationController

    init(container: Container, navigationController: UINavigationController = UINavigationController()) {
        self.container = container
        self.navigationController = navigationController
    }

    func start() {
        if let welcomeViewContraoller = R.storyboard.welcome().instantiateInitialViewController() as? WelcomeViewController {
            let welcomeViewModel = WelcomeViewModel()
            welcomeViewModel.coordinator = self
            welcomeViewContraoller.viewModel = welcomeViewModel
            navigationController.viewControllers = [welcomeViewContraoller]
            navigationController.navigationBar.isHidden = true
        }
    }

    enum Tab: Int {

        case translate = 0
        case history
    }

    func showTabBar(selectedTab: Tab) {
        let translate = TranslateCoordinator(container: container)
        let history = HistoryCoordinator(container: container)
        translate.start()
        history.start()
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [translate.navigationController, history.navigationController]
        tabBarController.selectedIndex = selectedTab.rawValue
        navigationController.pushViewController(tabBarController, animated: true)
    }

    // MARK: - Private
    private var container: Container
}
