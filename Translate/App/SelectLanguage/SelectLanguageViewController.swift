//
//  SelectLanguageViewController.swift
//  Translate
//
//  Created by Anton Pryakhin on 29.09.2020.
//

import Cartography
import UIKit
import RxSwift
import RxCocoa

class SelectLanguageViewController: UIViewController {
    
    // MARK: - ViewModel
    var viewModel: SelectLanguageViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
    }
    
    // MARK: - Private
    private lazy var navigationBar = UINavigationBar()
    private lazy var tableView = UITableView()
    
    private let disposeBag = DisposeBag()
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupTableView()
    }

    private func setupNavigationBar() {
        
        let navigationItem = UINavigationItem()
        let closeButton = UIButton()
        let closeButtonImage = UIImage(systemName: Constants.closeIcon)
        closeButton.setImage(closeButtonImage?.withTintColor(Constants.normalColor), for: .normal)
        closeButton.setImage(closeButtonImage?.withTintColor(Constants.highlightedColor, renderingMode: .alwaysOriginal), for: .highlighted)
        closeButton.addTarget(self, action: #selector(touchClose), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
        navigationBar.setItems([navigationItem], animated: true)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navigationBar)

        constrain(navigationBar, view) { navigationBar, view in
            navigationBar.top == view.safeAreaLayoutGuide.top
            navigationBar.left == view.left
            navigationBar.right == view.right
        }
    }
    
    private func setupTableView() {
        
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        tableView.register(LanguageCell.self, forCellReuseIdentifier: Constants.languageCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        constrain(tableView, navigationBar, view) { tableView, navigationBar, view in
            tableView.top == navigationBar.bottom
            tableView.left == view.left
            tableView.right == view.right
            tableView.bottom == view.bottom
        }
    }
    
    private func setupBindings() {
        
        setupTitle()
        setupTableViewCells()
    }
    
    private func setupTitle() {
        
        viewModel.languageType
            .subscribe(onNext: { [unowned self] languageType in
                switch languageType {
                case .source:
                    self.navigationBar.items?.first?.title = Constants.titleFrom
                case .target:
                    self.navigationBar.items?.first?.title = Constants.titleTo
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableViewCells() {
        
        viewModel.languages
            .bind(to: tableView.rx.items(cellIdentifier: Constants.languageCell,
                                         cellType: LanguageCell.self)) {
                [unowned self] (row, element, cell) in
                cell.textLabel?.text = element.name?.capitalized
                cell.isCheckmarked = element == self.viewModel.currentLanguage.value
            }
            .disposed(by: disposeBag)
        
        tableView.rx
             .modelSelected(Language.self)
             .subscribe(onNext: { [unowned self] language in
                self.viewModel.selectLanguage(language: language)
             })
             .disposed(by: disposeBag)
    }
    
    @objc
    private func touchClose() {
        viewModel.close()
    }
}

private enum Constants {

    static let normalColor = UIColor.systemBlue
    static let highlightedColor = normalColor.withAlphaComponent(0.3)
    
    static let titleFrom = "Translate from"
    static let titleTo = "Translate to"
    
    static let closeIcon = "xmark"
    
    static let languageCell = "LanguageCell"
}
