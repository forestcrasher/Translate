//
//  AppCoordinator.swift
//  Translate
//
//  Created by Anton Pryakhin on 06.09.2020.
//

import Swinject
import UIKit

class AppCoordinator: Coordinator {

    // MARK: - Public
    var rootViewController: UIViewController?

    init(container: Container) {
        self.container = container
    }

    func start() {
        if let welcomeViewContraoller = R.storyboard.welcome().instantiateInitialViewController() as? WelcomeViewController {
            let welcomeViewModel = WelcomeViewModel()
            welcomeViewModel.coordinator = self
            welcomeViewContraoller.viewModel = welcomeViewModel

            navigationController = UINavigationController()
            navigationController?.viewControllers = [welcomeViewContraoller]
            navigationController?.navigationBar.isHidden = true
            rootViewController = navigationController

            showTabBar(selectedTab: .translate)
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

        if let translateViewController = translate.rootViewController, let historyViewController = history.rootViewController {
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = [translateViewController, historyViewController]
            tabBarController.selectedIndex = selectedTab.rawValue
            tabBarController.navigationItem.hidesBackButton = true
            navigationController?.pushViewController(tabBarController, animated: true)
        }
    }

    // MARK: - Private
    private var container: Container
    private var navigationController: UINavigationController?
}
