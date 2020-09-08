//
//  HistoryCoodinator.swift
//  Translate
//
//  Created by Anton Pryakhin on 07.09.2020.
//

import Swinject
import UIKit

class HistoryCoordinator: Coordinator {

    // MARK: - Public
    var navigationController: UINavigationController

    init(container: Container, navigationController: UINavigationController = UINavigationController()) {
        self.container = container
        self.navigationController = navigationController
    }

    func start() {
        let historyViewModel = HistoryViewModel()
        historyViewModel.historyService = container.resolve(HistoryService.self)
        historyViewModel.coordinator = self
        let historyViewController = HistoryViewController()
        let tabBarItemImage = UIImage(systemName: "book")
        historyViewController.tabBarItem = UITabBarItem(title: "History", image: tabBarItemImage, selectedImage: tabBarItemImage)
        navigationController.viewControllers = [historyViewController]
    }

    // MARK: - Private
    private var container: Container
}
