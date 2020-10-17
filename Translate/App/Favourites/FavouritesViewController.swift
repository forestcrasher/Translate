//
//  FavouritesViewController.swift
//  Translate
//
//  Created by Anton Pryakhin on 06.09.2020.
//

import Cartography
import UIKit

class FavouritesViewController: UIViewController {

    // MARK: - ViewModel
    var viewModel: FavouritesViewModel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = Constants.title
        view.backgroundColor = UIColor.white

        setupTableView()
    }

    // MARK: - Private
    private lazy var tableView = UITableView()

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        constrain(tableView, view) { tableView, view in
            tableView.top == view.safeAreaLayoutGuide.top
            tableView.left == view.left
            tableView.right == view.right
            tableView.bottom == view.safeAreaLayoutGuide.bottom
        }
    }
}

private enum Constants {

    static let title = "Favourites"
}
