//
//  ShapeButton.swift
//  Translate
//
//  Created by Anton Pryakhin on 08.09.2020.
//

import UIKit

@IBDesignable
class ShapeButton: UIButton {

    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = 8.0
    }
}
