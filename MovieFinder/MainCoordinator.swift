//
//  MainCoordinator.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 5.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

protocol MainCoordinatorDelegate: class {

}

class MainCoordinator: BaseCoordinator {

    private let navigationController: UINavigationController
    private var mainVC: MainVC!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        mainVC = MainVC()
        mainVC.delegate = self
        navigationController.pushViewController(mainVC, animated: true)
    }
}

extension MainCoordinator: MainCoordinatorDelegate {

}
