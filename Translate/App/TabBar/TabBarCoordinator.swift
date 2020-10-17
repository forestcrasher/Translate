//
//  TabBarCoordinator.swift
//  Translate
//
//  Created by Anton Pryakhin on 05.10.2020.
//

import Swinject
import UIKit

class TabBarCoordinator: Coordinator {

    // MARK: - Init
    init(container: Container) {
        self.container = container
    }

    // MARK: - Public
    var rootViewController: UIViewController?

    enum Tab: Int {

        case translate = 0
        case favourites
    }
    
    func start() {
        
        let tabBarController = UITabBarController()
        tabBarController.navigationItem.hidesBackButton = true

        let translate = TranslateCoordinator(container: container)
        let favourites = FavouritesCoordinator(container: container)
        translate.start()
        favourites.start()

        if let translateViewController = translate.rootViewController, let favouritesViewConroller = favourites.rootViewController {
            tabBarController.viewControllers = [translateViewController, favouritesViewConroller].map {
                UINavigationController(rootViewController: $0)
            }
        }
        
        rootViewController = tabBarController
    }
    
    func selectTab(tab: Tab) {
        
        if let tabBarController = rootViewController as? UITabBarController {
            tabBarController.selectedIndex = tab.rawValue
        }
    }

    // MARK: - Private
    private var container: Container
}

