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
        case history
    }
    
    func start() {
        
        let tabBarController = UITabBarController()
        tabBarController.navigationItem.hidesBackButton = true

        let translate = TranslateCoordinator(container: container)
        let history = HistoryCoordinator(container: container)
        translate.start()
        history.start()

        if let translateViewController = translate.rootViewController, let historyViewConroller = history.rootViewController {
            tabBarController.viewControllers = [translateViewController, historyViewConroller].map {
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

