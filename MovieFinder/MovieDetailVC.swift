//
//  MovieDetailVC.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 6.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class MovieDetailVC: UIViewController {

    private var movie: Movie?
    // TODO private var tvShow: TVShow?
    // TODO private var favourite: Favourite?
    unowned var posterCell: PosterCell

    let detailView = MovieDetailView()
    
    private let interactor = Interactor()

    init(movie: Movie, posterCell: PosterCell) {
        self.movie = movie
        self.posterCell = posterCell
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .custom
        transitioningDelegate = self
        detailView.posterImageView.image = posterCell.imageView.image
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func loadView() {
        super.loadView()
        detailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailView)
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailView.leftAnchor.constraint(equalTo: view.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.rightAnchor),
            ])
    }

    var interactionController: UIPercentDrivenInteractiveTransition?
    override func viewDidLoad() {
        super.viewDidLoad()

        let testGesture = UITapGestureRecognizer(target: self, action: #selector(bla))
        view.addGestureRecognizer(testGesture)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func bla() {
        dismiss(animated: true, completion: nil)
    }



}

// MARK: - Pan gesture

extension MovieDetailVC: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {

        let percentThreshold:CGFloat = 0.2

        guard detailView.scrollView.contentOffset.y <= 0  else { return }

        switch gesture.state {
        case .began:
            if gesture.velocity(in: view).y >= 0 {
                interactor.hasStarted = true
                dismiss(animated: true)
            }
        case .changed:
            if interactor.hasStarted {
                // convert y-position to downward pull progress (percentage)
                let translationY = gesture.translation(in: view).y * 2
                let verticalMovement = translationY / view.bounds.height
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
}

// MARK: - Custom transition Transition (MainVC -> MovieDetailVC)

extension MovieDetailVC: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MovieDetailPresentTransition()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MovieDetailDismissTransition()
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
