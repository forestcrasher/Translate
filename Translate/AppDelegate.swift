//
//  AppDelegate.swift
//  Translate
//
//  Created by Anton Pryakhin on 05.09.2020.
//

import Swinject
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let container = Container { container in
            container.register(TranslateService.self) { _ in TranslateService() }
            container.register(HistoryService.self) { _ in HistoryService() }
        }

        let coordinator = WelcomeCoordinator(container: container)
        coordinator.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = coordinator.navigationController
        window?.makeKeyAndVisible()

        return true
    }
}
