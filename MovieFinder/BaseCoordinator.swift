//
//  BaseCoordinator.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 5.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

class BaseCoordinator: NSObject, Coordinator {

    var childCoordinators: [Coordinator] = []
    var isCompleted: (() -> Void)?

    func start() {
        fatalError("Children should implement 'start'.")
    }
}
