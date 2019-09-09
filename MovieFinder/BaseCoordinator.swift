//
//  BaseCoordinator.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 5.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation



class BaseCoordinator: NSObject, Coordinator, CoordinatorDelegate {

    var childCoordinators: [Coordinator] = []
    weak var delegate: CoordinatorDelegate?
    
    func start() {
        fatalError("Children should implement 'start'.")
    }

    func subCoordinatorIsCompleted(coordinator: Coordinator) {
        self.free(coordinator: coordinator)
    }
}
