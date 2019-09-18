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
    func detail(movie: Movie, posterCell: PosterCell)
    func detail(tvShow: TVShow, posterCell: PosterCell)
    func imagesViewer(imageURLs: [URL], firstIndex: Int)
    func playYoutubeVideo(videoID: String)
}

class MovieDetailCoordinator: BaseCoordinator {

    private unowned let rootViewController: UIViewController
    private unowned var detailVC: MovieDetailVC!
    private unowned var posterCell: PosterCell
    private var movie: Movie?
    private var tvShow: TVShow?
    private var showSimilar: Bool

    private var interactor = Interactor()

    init(rootViewController: UIViewController, movie: Movie, posterCell: PosterCell, showSimilar: Bool = true) {
        self.rootViewController = rootViewController
        self.movie = movie
        self.posterCell = posterCell
        self.showSimilar = showSimilar
    }

    init(rootViewController: UIViewController, tvShow: TVShow, posterCell: PosterCell, showSimilar: Bool = true) {
        self.rootViewController = rootViewController
        self.tvShow = tvShow
        self.posterCell = posterCell
        self.showSimilar = showSimilar
    }

    override func start() {

        var detailVC: MovieDetailVC?
        if let movie = movie {
            detailVC = MovieDetailVC(movie: movie, image: posterCell.imageView.image, showSimilar: showSimilar)
        } else if let tvShow = tvShow {
            detailVC = MovieDetailVC(tvShow: tvShow, image: posterCell.imageView.image, showSimilar: showSimilar)
        }
        if let detailVC = detailVC {
            self.detailVC = detailVC
            detailVC.modalPresentationStyle = .custom
            detailVC.transitioningDelegate = self
            detailVC.delegate = self
            rootViewController.present(detailVC, animated: true)
        } else {
            fatalError("MovieDetailCoordinator: MovieDetailVC no valid data")
        }
    }
}

// MARK: - Custom Transition (MainVC -> MovieDetailVC)

extension MovieDetailCoordinator: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let _ = presented as? MovieDetailVC else { return nil }
        return MovieDetailPresentTransition(posterCell: posterCell)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let _ = dismissed as? MovieDetailVC else { return nil }
        return MovieDetailDismissTransition(posterCell: posterCell)
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

// MARK: - Coordinator Delegate

extension MovieDetailCoordinator: MovieDetailCoordinatorDelegate {

    func detail(movie: Movie, posterCell: PosterCell) {

        let movieDetailCoordinator = MovieDetailCoordinator(rootViewController: detailVC,
                                                            movie: movie,
                                                            posterCell: posterCell,
                                                            showSimilar: false)
        self.store(coordinator: movieDetailCoordinator)
        movieDetailCoordinator.delegate = self
        movieDetailCoordinator.start()
    }

    func detail(tvShow: TVShow, posterCell: PosterCell) {

        let movieDetailCoordinator = MovieDetailCoordinator(rootViewController: detailVC,
                                                            tvShow: tvShow,
                                                            posterCell: posterCell,
                                                            showSimilar: false)
        self.store(coordinator: movieDetailCoordinator)
        movieDetailCoordinator.delegate = self
        movieDetailCoordinator.start()
    }

    func imagesViewer(imageURLs: [URL], firstIndex: Int) {

        let imagesViewerVC = ImagesViewerVC(photosURLs: imageURLs, firstIndex: firstIndex)
        detailVC.present(imagesViewerVC, animated: true)
    }


    func playYoutubeVideo(videoID: String) {

        let youtubePlayerVC = YoutubePlayerVC(videoID: videoID)
        youtubePlayerVC.modalPresentationStyle = .overCurrentContext
        youtubePlayerVC.modalTransitionStyle = .coverVertical
        detailVC.present(youtubePlayerVC, animated: true)
    }

    func handleGestureDismissTransition(gesture: UIPanGestureRecognizer) {

        let percentThreshold:CGFloat = 0.01
        switch gesture.state {

        case .began:
            if gesture.velocity(in: detailVC.view).y >= 0 {
                interactor.hasStarted = true
                detailVC.disableScroll()
                detailVC.dismiss(animated: true) { [weak self] in
                    guard let self = self else { return }
                    if self.interactor.shouldFinish {
                        self.delegate?.subCoordinatorIsCompleted(coordinator: self)
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
                detailVC.enableScroll()
            }

        case .ended:
            if interactor.hasStarted {

                interactor.hasStarted = false
                if interactor.shouldFinish {
                    interactor.finish()
                } else {
                    interactor.cancel()
                    detailVC.enableScroll()
                }
            }

        default: break
        }
    }

    func dismissMovieDetail() {
        detailVC.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.delegate?.subCoordinatorIsCompleted(coordinator: self)
        }
    }
}


