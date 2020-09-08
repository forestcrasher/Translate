//
//  TranslateCoordinator.swift
//  Translate
//
//  Created by Anton Pryakhin on 07.09.2020.
//

import Swinject
import UIKit

class TranslateCoordinator: Coordinator {

    // MARK: - Public
    var rootViewController: UIViewController?

    init(container: Container) {
        self.container = container
    }

    func start() {
        let translateViewModel = TranslateViewModel()
        translateViewModel.translateService = container.resolve(TranslateService.self)
        translateViewModel.historyService = container.resolve(HistoryService.self)
        translateViewModel.coordinator = self

        let translateViewController = TranslateViewController()
        let tabBarItemImage = UIImage(systemName: "globe")
        translateViewController.tabBarItem = UITabBarItem(title: "Translate", image: tabBarItemImage, selectedImage: tabBarItemImage)

        navigationController = UINavigationController()
        navigationController?.viewControllers = [translateViewController]
        rootViewController = navigationController
    }

    // MARK: - Private
    private var container: Container
    private var navigationController: UINavigationController?
}
