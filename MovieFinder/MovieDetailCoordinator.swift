//
//  MovieDetailCoordinator.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 8.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

protocol MovieDetailCoordinatorDelegate: class {
    func dismissMovieDetail()
    func handleGestureDismissTransition(gesture: UIPanGestureRecognizer)
}

class MovieDetailCoordinator: BaseCoordinator {

    private let navigationController: UINavigationController
    private var detailVC: MovieDetailVC!
    private var posterCell: PosterCell
    private var movie: Movie?

    private let interactor = Interactor()

    init(navigationController: UINavigationController, movie: Movie, posterCell: PosterCell) {
        self.navigationController = navigationController
        self.movie = movie
        self.posterCell = posterCell
    }

    override func start() {

        if let movie = movie {
            detailVC = MovieDetailVC(movie: movie, image: posterCell.imageView.image, interactor: interactor)
        }
        if let detailVC = detailVC {
            detailVC.modalPresentationStyle = .custom
            detailVC.transitioningDelegate = self
            detailVC.delegate = self
            navigationController.present(detailVC, animated: true)
        } else {
            fatalError("MovieDetailCoordinator: MovieDetailVC not initialized")
        }
    }
}

// MARK: - Custom Transition (MainVC -> MovieDetailVC)

extension MovieDetailCoordinator: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MovieDetailPresentTransition(posterCell: posterCell)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MovieDetailDismissTransition(posterCell: posterCell)
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

// MARK: - Gesture Dismiss

extension MovieDetailCoordinator: MovieDetailCoordinatorDelegate {

    func handleGestureDismissTransition(gesture: UIPanGestureRecognizer) {

        let percentThreshold:CGFloat = 0.2
        switch gesture.state {
        case .began:
            if gesture.velocity(in: detailVC.view).y >= 0 {
                interactor.hasStarted = true
                detailVC.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    if self.interactor.shouldFinish {
                        self.isCompleted?()
                    }
                }
            }
        case .changed:
            if interactor.hasStarted {
                // convert y-position to downward pull progress (percentage)
                let translationY = gesture.translation(in: detailVC.view).y * 2
                let verticalMovement = translationY / detailVC.view.bounds.height
                let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
                let downwardMovementPercent = fminf(downwardMovement, 1.0)
                let progress = CGFloat(downwardMovementPercent)
                interactor.shouldFinish = progress > percentThreshold
                interactor.update(progress)
            }
        case .cancelled:
            if interactor.hasStarted {
                interactor.hasStarted = false
                interactor.cancel()
            }
        case .ended:
            if interactor.hasStarted {
                interactor.hasStarted = false
                interactor.shouldFinish
                    ? interactor.finish()
                    : interactor.cancel()
            }
        default:
            break
        }
    }

    func dismissMovieDetail() {
        detailVC.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.isCompleted?()
        }
    }
}


