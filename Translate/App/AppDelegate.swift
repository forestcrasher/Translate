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

    var coordinator: Coordinator?
    var window: UIWindow?

    let container = Container { container in
        container.register(AuthorizationService.self) { _ in AuthorizationService() }
        container.register(TranslateService.self) { resolver in
            return TranslateService(authorizationService: resolver.resolve(AuthorizationService.self))
        }
        container.register(FavouritesService.self) { _ in FavouritesService() }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        coordinator = AppCoordinator(container: container)
        coordinator?.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = coordinator?.rootViewController
        window?.makeKeyAndVisible()

        return true
    }
}
