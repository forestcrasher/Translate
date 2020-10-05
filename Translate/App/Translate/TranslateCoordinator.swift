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
        rootViewController = translateViewController
    }
    
    func showSelectionSourceLanguage(languages: [Language], currentLanguage: Language?) {
        
        let selectionLanguageViewModel = SelectionLanguageViewModel(languages: languages, currentLanguage: currentLanguage, languageType: .source)
        selectionLanguageViewModel.coordinator = self
        let selectionLanguageViewController = SelectionLanguageViewController()
        selectionLanguageViewController.viewModel = selectionLanguageViewModel
        rootViewController?.present(selectionLanguageViewController, animated: true)
    }
    
    func showSelectionTargetLanguage(languages: [Language], currentLanguage: Language?) {
        
        let selectionLanguageViewModel = SelectionLanguageViewModel(languages: languages, currentLanguage: currentLanguage, languageType: .target)
        selectionLanguageViewModel.coordinator = self
        let selectionLanguageViewController = SelectionLanguageViewController()
        selectionLanguageViewController.viewModel = selectionLanguageViewModel
        rootViewController?.present(selectionLanguageViewController, animated: true)
    }
    
    func hideSelectionLanguage() {
        
        rootViewController?.presentedViewController?.dismiss(animated: true)
    }
    
    func hideSelectionSourceLanguage(selectedLanguage: Language) {
        
        if let translateViewController = rootViewController as? TranslateViewController {
            translateViewController.viewModel.setCurrentSourceLanguage(language: selectedLanguage)
        }
        
        hideSelectionLanguage()
    }
    
    func hideSelectionTargetLanguage(selectedLanguage: Language) {
        
        if let translateViewController = rootViewController as? TranslateViewController {
            translateViewController.viewModel.setCurrentTargetLanguage(language: selectedLanguage)
        }
        
        hideSelectionLanguage()
    }

    // MARK: - Private
    private var container: Container
}

private enum Constants {

    static let translateTitle = "Translate"
    static let translateIcon = "globe"
}
