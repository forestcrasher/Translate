//
//  FavouritesCoodinator.swift
//  Translate
//
//  Created by Anton Pryakhin on 07.09.2020.
//

import Swinject
import UIKit

class FavouritesCoordinator: Coordinator {

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

    // MARK: - Public
    var rootViewController: UIViewController?

    func start() {
        let favouritesViewModel = FavouritesViewModel()
        favouritesViewModel.favouritesService = container.resolve(FavouritesService.self)
        favouritesViewModel.coordinator = self
        let favouritesViewController = FavouritesViewController()
        let tabBarItemImage = UIImage(systemName: Constants.favouritesIcon)
        favouritesViewController.tabBarItem = UITabBarItem(title: Constants.favouritesTitle, image: tabBarItemImage, selectedImage: tabBarItemImage)
        rootViewController = favouritesViewController
    }

    // MARK: - Private
    private var container: Container
}

private enum Constants {

    static let favouritesTitle = "Favourites"
    static let favouritesIcon = "star"
}
