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
    var rootViewController: UIViewController?

    init(container: Container) {
        self.container = container
    }

    func start() {
        let historyViewModel = HistoryViewModel()
        historyViewModel.historyService = container.resolve(HistoryService.self)
        historyViewModel.coordinator = self

        let historyViewController = HistoryViewController()
        let tabBarItemImage = UIImage(systemName: "book")
        historyViewController.tabBarItem = UITabBarItem(title: "History", image: tabBarItemImage, selectedImage: tabBarItemImage)

        navigationController = UINavigationController()
        navigationController?.viewControllers = [historyViewController]
        rootViewController = navigationController
    }

    // MARK: - Private
    private var container: Container
    private var navigationController: UINavigationController?
}
