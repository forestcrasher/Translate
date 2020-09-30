//
//  LanguageCell.swift
//  Translate
//
//  Created by Anton Pryakhin on 30.09.2020.
//

import Cartography
import UIKit

class LanguageCell: UITableViewCell {

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        addSubview(checkmarkImageView)
        constrain(checkmarkImageView, self) { checkmarkImageView, view in
            checkmarkImageView.width == Constants.iconWidth
            checkmarkImageView.height == Constants.iconHeight
            checkmarkImageView.right == view.right - Constants.horizontalPadding
            checkmarkImageView.centerY == view.centerY
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    var isCheckmarked: Bool = false {
        didSet {
            checkmarkImageView.isHidden = !isCheckmarked
        }
    }
    
    // MARK: - Private
    private lazy var checkmarkImageView: UIImageView = {
        let checkmarkImageView = UIImageView(image: UIImage(systemName: Constants.checkmarkIcon)?.withTintColor(Constants.normalColor))
        checkmarkImageView.isHidden = true
        checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
        return checkmarkImageView
    }()
}

private enum Constants {

    static let normalColor = UIColor.systemBlue

    static let horizontalPadding: CGFloat = 16.0
    static let iconWidth: CGFloat = 16.0
    static let iconHeight: CGFloat = 16.0

    static let checkmarkIcon = "checkmark"
}
