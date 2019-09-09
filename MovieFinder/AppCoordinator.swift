//
//  AppCoordinator.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 5.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class AppCoordinator: BaseCoordinator {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    override func start() {

        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true

        let mainCoordinator = MainCoordinator(navigationController: navigationController)
        mainCoordinator.delegate = self
        self.store(coordinator: mainCoordinator)
        mainCoordinator.start()

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

}
