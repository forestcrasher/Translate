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
    
    func showSelectionLanguageFrom(languages: [Language], currentLanguage: Language?) {
        let selectLanguageViewModel = SelectLanguageViewModel(coordinator: self,
                                                              languages: languages,
                                                              currentLanguage: currentLanguage,
                                                              languageType: .from)
        let selectLanguageViewController = SelectLanguageViewController()
        selectLanguageViewController.viewModel = selectLanguageViewModel
        rootViewController?.present(selectLanguageViewController, animated: true)
    }
    
    func showSelectionLanguageTo(languages: [Language], currentLanguage: Language?) {
        let selectLanguageViewModel = SelectLanguageViewModel(coordinator: self,
                                                              languages: languages,
                                                              currentLanguage: currentLanguage,
                                                              languageType: .to)
        let selectLanguageViewController = SelectLanguageViewController()
        selectLanguageViewController.viewModel = selectLanguageViewModel
        rootViewController?.present(selectLanguageViewController, animated: true)
    }
    
    func hideSelectionLanguage() {
        if let rootViewController = rootViewController as? UINavigationController {
            rootViewController.visibleViewController?.dismiss(animated: true)
        }
    }
    
    func hideSelectionLanguageFrom(selectedLanguage: Language) {
        if let rootViewController = rootViewController as? UINavigationController,
           let selectLanguageViewController = rootViewController.topViewController as? TranslateViewController {
            selectLanguageViewController.viewModel.setCurrentLanguageFrom(language: selectedLanguage)
        }
        hideSelectionLanguage()
    }
    
    func hideSelectionLanguageTo(selectedLanguage: Language) {
        if let rootViewController = rootViewController as? UINavigationController,
           let selectLanguageViewController = rootViewController.topViewController as? TranslateViewController {
            selectLanguageViewController.viewModel.setCurrentLanguageTo(language: selectedLanguage)
        }
        hideSelectionLanguage()
    }

    // MARK: - Private
    private var container: Container
    private var navigationController: UINavigationController?
}
