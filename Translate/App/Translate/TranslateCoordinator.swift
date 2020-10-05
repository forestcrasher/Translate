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
        let translateViewModel = TranslateViewModel()
        translateViewModel.translateService = container.resolve(TranslateService.self)
        translateViewModel.historyService = container.resolve(HistoryService.self)
        translateViewModel.coordinator = self
        let translateViewController = TranslateViewController()
        translateViewController.viewModel = translateViewModel
        let tabBarItemImage = UIImage(systemName: Constants.translateIcon)
        translateViewController.tabBarItem = UITabBarItem(title: Constants.translateTitle, image: tabBarItemImage, selectedImage: tabBarItemImage)

        navigationController = UINavigationController()
        navigationController?.viewControllers = [translateViewController]
        rootViewController = navigationController
    }
    
    func showSelectionSourceLanguage(languages: [Language], currentLanguage: Language?) {
        let selectLanguageViewModel = SelectionLanguageViewModel(languages: languages, currentLanguage: currentLanguage, languageType: .source)
        selectLanguageViewModel.coordinator = self
        let selectLanguageViewController = SelectionLanguageViewController()
        selectLanguageViewController.viewModel = selectLanguageViewModel
        rootViewController?.present(selectLanguageViewController, animated: true)
    }
    
    func showSelectionTargetLanguage(languages: [Language], currentLanguage: Language?) {
        let selectLanguageViewModel = SelectionLanguageViewModel(languages: languages, currentLanguage: currentLanguage, languageType: .target)
        selectLanguageViewModel.coordinator = self
        let selectLanguageViewController = SelectionLanguageViewController()
        selectLanguageViewController.viewModel = selectLanguageViewModel
        rootViewController?.present(selectLanguageViewController, animated: true)
    }
    
    func hideSelectionLanguage() {
        if let rootViewController = rootViewController as? UINavigationController {
            rootViewController.visibleViewController?.dismiss(animated: true)
        }
    }
    
    func hideSelectionSourceLanguage(selectedLanguage: Language) {
        if let rootViewController = rootViewController as? UINavigationController,
           let selectLanguageViewController = rootViewController.topViewController as? TranslateViewController {
            selectLanguageViewController.viewModel.setCurrentSourceLanguage(language: selectedLanguage)
        }
        
        hideSelectionLanguage()
    }
    
    func hideSelectionTargetLanguage(selectedLanguage: Language) {
        if let rootViewController = rootViewController as? UINavigationController,
           let selectLanguageViewController = rootViewController.topViewController as? TranslateViewController {
            selectLanguageViewController.viewModel.setCurrentTargetLanguage(language: selectedLanguage)
        }
        
        hideSelectionLanguage()
    }

    // MARK: - Private
    private var container: Container
    private var navigationController: UINavigationController?
}

private enum Constants {

    static let translateTitle = "Translate"
    static let translateIcon = "globe"
}
