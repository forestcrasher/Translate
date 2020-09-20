//
//  TranslateCoordinator.swift
//  Translate
//
//  Created by Anton Pryakhin on 07.09.2020.
//

import Swinject
import UIKit

class TranslateCoordinator: Coordinator {

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

    // MARK: - Public
    var rootViewController: UIViewController?

    func start() {
        let translateViewModel = TranslateViewModel(container: container, coordinator: self)
        let translateViewController = TranslateViewController()
        translateViewController.viewModel = translateViewModel
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
