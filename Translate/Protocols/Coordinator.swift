//
//  Coordinator.swift
//  Translate
//
//  Created by Anton Pryakhin on 07.09.2020.
//

import UIKit

protocol Coordinator {

    var rootViewController: UIViewController? { get set }

    func start()
}
