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


    private var disablePosterDragging = false

    init(movie: Movie, image: UIImage?) {
        self.movie = movie
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

        setupScrollView()
        setupActions()
        setupGestures()
        setBasicInfo()
        loadDetailData()
    }
}

// MARK: - Actions

extension MovieDetailVC {

    private func setupActions() {

        detailView.dismissBtn.addTarget(self, action: #selector(dismissAction(_:)), for: .touchUpInside)
        detailView.posterDismissBtn.addTarget(self, action: #selector(dismissAction(_:)), for: .touchUpInside)
        detailView.homepageBtn.addTarget(self, action: #selector(homepageAction(_:)), for: .touchUpInside)
    }

    @objc func dismissAction(_ sender: Any) {
        delegate?.dismissMovieDetail()
    }

    @objc func homepageAction(_ sender: Any) {
        if let movie = movie, let homepage = movie.homepage {
            UIApplication.shared.open(homepage)
        }
    }
}

// MARK: - Set data

extension MovieDetailVC {

    private func setBasicInfo() {

        if let movie = movie {
            detailView.setBasicInfo(title: movie.title,
                                    description: movie.overview,
                                    rating: movie.voteAverage,
                                    genresNames: GenresData.movieGenreNames(ids: movie.genreIds),
                                    date: movie.releaseDate)
        }
        // TODO else if let tvShow = tvShow
        // TODO else if let favourite = favourite
    }

    private func setDetailInfo(movie: Movie) {

        self.movie = movie

        if let minutes = movie.runtime {
            let h: Int = Int(minutes) / 60
            let m: Int = Int(minutes) % 60
            let runtimeString = h > 0 ? "\(h)h \(m)min" : "\(m)min"
            detailView.durationLabel.text = runtimeString
            detailView.durationLabel.isHidden = false
        }

        if let homepage = movie.homepage, let host = homepage.host {
            let homepageAttributes: [NSAttributedString.Key: Any] = [ NSAttributedString.Key.foregroundColor: UIColor.movieFinder.tertiery,
                                                                      .underlineStyle: NSUnderlineStyle.single.rawValue] //.double.rawValue, .thick.rawValue
            let homepageString = NSMutableAttributedString(string: host, attributes: homepageAttributes)
            detailView.homepageBtn.setAttributedTitle(homepageString, for: .normal)
            detailView.homepageBtn.isHidden = false
        }

        detailView.animateLayout()
    }

}

// MARK: - Load detail data

extension MovieDetailVC {

    private func loadDetailData() {

        if let movie = movie {
            loadMovieDetail(id: movie.id)
        }
    }

    private func loadMovieDetail(id: Int) {
        MovieAPI.shared.GET(endpoint: .movieDetail(movie: id),
                             params: ["append_to_response": "credits,images,videos,similar"],
                             printDebug: false) { [weak self] (result: Result<Movie,MovieAPIError>) in
                                guard let self = self else { return }
                                switch result {
                                case .success(let movie): self.setDetailInfo(movie: movie)
                                case .failure(let error): print(error)
                                }
        }
    }
}


// MARK: - ScrollView delegate

extension MovieDetailVC: UIScrollViewDelegate {

    private func setupScrollView()  {
        detailView.scrollView.delegate = self
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        disablePosterDragging = scrollView.contentOffset.y == 0 && detailView.scrollView.panGestureRecognizer.velocity(in: detailView.scrollView).y > 0
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        disablePosterDragging = false
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !disablePosterDragging {
            let translationY = -scrollView.contentOffset.y //scrollIsDragging ? min(0, -scrollView.contentOffset.y) : -scrollView.contentOffset.y
            detailView.posterView.transform = CGAffineTransform(translationX: 0, y: translationY)
        } else {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
}

// MARK: - Pan Gesture dismiss transition

extension MovieDetailVC: UIGestureRecognizerDelegate {

    private func setupGestures() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard detailView.scrollView.contentOffset.y <= 0  else { return }
        delegate?.handleGestureDismissTransition(gesture: gesture)
    }
}

