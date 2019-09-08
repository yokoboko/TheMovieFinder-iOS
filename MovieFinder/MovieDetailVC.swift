//
//  MovieDetailVC.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 6.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class MovieDetailVC: UIViewController {

    weak var delegate: MovieDetailCoordinatorDelegate?

    private var movie: Movie?
    // TODO private var tvShow: TVShow?
    // TODO private var favourite: Favourite?

    let detailView = MovieDetailView()
    
    private var interactor: Interactor

    init(movie: Movie, image: UIImage?, interactor: Interactor) {
        self.movie = movie
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        detailView.posterImageView.image = image
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

        let testGesture = UITapGestureRecognizer(target: self, action: #selector(closeMovieDetail))
        view.addGestureRecognizer(testGesture)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func closeMovieDetail() {
        delegate?.dismissMovieDetail()
    }
}

// MARK: - Pan Gesture dismiss transition

extension MovieDetailVC: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard detailView.scrollView.contentOffset.y <= 0  else { return }
        delegate?.handleGestureDismissTransition(gesture: gesture)
    }
}

