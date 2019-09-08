//
//  MainCoordinator.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 5.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

protocol MainCoordinatorDelegate: class {
    func pickGenres(genreType: GenreType, completion: @escaping (_ selected: [Genre]) -> Void, selected: [Genre]?)
    func detail(movie: Movie, posterCell: PosterCell)
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

    func detail(movie: Movie, posterCell: PosterCell) {

        let movieDetailCoordinator = MovieDetailCoordinator(navigationController: navigationController,
                                                             movie: movie,
                                                             posterCell: posterCell)
        movieDetailCoordinator.isCompleted = { [weak self] in
            self?.free(coordinator: movieDetailCoordinator)
        }
        self.store(coordinator: movieDetailCoordinator)
        movieDetailCoordinator.start()
    }

    func pickGenres(genreType: GenreType, completion: @escaping (_ selected: [Genre]) -> Void, selected: [Genre]?) {
        let genrePickerVC = GenrePickerVC(genreType: genreType, completion: completion, selected: selected)
        genrePickerVC.modalPresentationStyle = .overCurrentContext
        genrePickerVC.modalTransitionStyle = .coverVertical
        navigationController.present(genrePickerVC, animated: true, completion: nil)
    }
}
