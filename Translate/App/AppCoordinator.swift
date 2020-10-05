//
//  AppCoordinator.swift
//  Translate
//
//  Created by Anton Pryakhin on 06.09.2020.
//

import Swinject
import UIKit

class AppCoordinator: Coordinator {

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

    // MARK: - Public
    var rootViewController: UIViewController?

    func start() {
        
        if let welcomeViewContraoller = R.storyboard.welcome().instantiateInitialViewController() as? WelcomeViewController {
            let welcomeViewModel = WelcomeViewModel()
            welcomeViewModel.coordinator = self
            welcomeViewContraoller.viewModel = welcomeViewModel

            navigationController = UINavigationController()
            navigationController?.viewControllers = [welcomeViewContraoller]
            navigationController?.navigationBar.isHidden = true
            rootViewController = navigationController
        }
    }

    func showTranslate() {
        
        let tabBar = TabBarCoordinator(container: container)
        tabBar.start()
        tabBar.selectTab(tab: .translate)
        
        if let tabBarController = tabBar.rootViewController {
            navigationController?.pushViewController(tabBarController, animated: true)
        }
    }
    
    func showHistory() {
        
        let tabBar = TabBarCoordinator(container: container)
        tabBar.start()
        tabBar.selectTab(tab: .history)
        
        if let tabBarController = tabBar.rootViewController {
            navigationController?.pushViewController(tabBarController, animated: true)
        }
    }

    // MARK: - Private
    private var container: Container
    private var navigationController: UINavigationController?
}
