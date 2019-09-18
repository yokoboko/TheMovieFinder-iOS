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
    private var tvShow: TVShow?
    // TODO private var favourite: Favourite?

    let detailView = MovieDetailView()

    private var trailerDataSource: TrailerDataSource?
    private var imageDataSource: ImageDataSource?
    private var castDataSource: CastDataSource?
    private var similarMovieDataSource: SimilarMovieDataSource?
    private var similarTVShowDataSource: SimilarTVShowDataSource?

    private var disablePosterDragging = false
    private var collectionViewDragging = false
    private var showSimilar = true

    init(movie: Movie, image: UIImage?, showSimilar: Bool = true) {
        self.movie = movie
        self.showSimilar = showSimilar
        super.init(nibName: nil, bundle: nil)
        detailView.posterImageView.image = image
    }

    init(tvShow: TVShow, image: UIImage?, showSimilar: Bool = true) {
        self.tvShow = tvShow
        self.showSimilar = showSimilar
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

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupActions()
        setupGestures()
        setBasicInfo()
        loadDetailData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - Actions

extension MovieDetailVC {

    private func setupActions() {

        detailView.dismissBtn.addTarget(self, action: #selector(dismissAction(_:)), for: .touchUpInside)
        detailView.posterDismissBtn.addTarget(self, action: #selector(dismissAction(_:)), for: .touchUpInside)
        detailView.homepageBtn.addTarget(self, action: #selector(homepageAction(_:)), for: .touchUpInside)
        detailView.favouriteBtn.addTarget(self, action: #selector(favouriteAction(_:)), for: .touchUpInside)
    }

    @objc func dismissAction(_ sender: Any) {
        detailView.scrollView.delegate = nil
        delegate?.dismissMovieDetail()
    }

    @objc func homepageAction(_ sender: Any) {
        if let movie = movie, let homepage = movie.homepage {
            UIApplication.shared.open(homepage)
        } else if let tvShow = tvShow, let homepage = tvShow.homepage {
            UIApplication.shared.open(homepage)
        }
    }

    @objc func favouriteAction(_ sender: Any) {
        //print(detailView.favouriteBtn.isSelected)
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
        } else if let tvShow = tvShow {
            detailView.genreLabel.numberOfLines = 2
            detailView.setBasicInfo(title: tvShow.originalName,
                                    description: tvShow.overview,
                                    rating: tvShow.voteAverage,
                                    genresNames: GenresData.movieGenreNames(ids: tvShow.genreIds),
                                    date: tvShow.firstAirDate, tvDate: true)
        }
    }

    private func setDetailInfo(movie: Movie) {

        self.movie = movie

        // Set detail info
        detailView.setDetailInfo(runtime: movie.runtime,
                                 homepage: movie.homepage)

        // Trailers
        if let videosResponse = movie.videos, !videosResponse.results.isEmpty {
            let filteredTrailers = videosResponse.results.filter { $0.site == "YouTube" }
            if !filteredTrailers.isEmpty {
                trailerDataSource = TrailerDataSource(trailers: filteredTrailers)
                detailView.trailersSV.isHidden = false
                detailView.trailersSV.alpha = 0
                detailView.trailersCV.delegate = self
                detailView.trailersCV.dataSource = trailerDataSource
            }
        }

        // Photos
        if let images = movie.images, !images.backdrops.isEmpty {
            let filteredBackgropImages = images.backdrops.filter { $0.aspect != nil && $0.filePath != nil }
             if !filteredBackgropImages.isEmpty {
                imageDataSource = ImageDataSource(images: filteredBackgropImages)
                detailView.imagesSV.isHidden = false
                detailView.imagesSV.alpha = 0
                detailView.imagesCV.delegate = self
                detailView.imagesCV.dataSource = imageDataSource
            }
        }

        // Cast
        if let credits = movie.credits, !credits.cast.isEmpty {
            castDataSource = CastDataSource(cast: credits.cast)
            detailView.castSV.isHidden = false
            detailView.castSV.alpha = 0
            detailView.castCV.delegate = self
            detailView.castCV.dataSource = castDataSource
        }

        // Similar
        if showSimilar, let similarResponse = movie.similar, !similarResponse.results.isEmpty {
            similarMovieDataSource = SimilarMovieDataSource(movies: similarResponse.results)
            detailView.similarSV.isHidden = false
            detailView.similarSV.alpha = 0
            detailView.similarCV.delegate = self
            detailView.similarCV.dataSource = similarMovieDataSource
        }

        // FadeIn Animation
        UIView.animate(withDuration: 0.3) {
            if !self.detailView.durationLabel.isHidden { self.detailView.durationLabel.alpha = 1 }
            if !self.detailView.homepageBtn.isHidden { self.detailView.homepageBtn.alpha = 1 }
            if !self.detailView.trailersSV.isHidden { self.detailView.trailersSV.alpha = 1 }
            if !self.detailView.imagesSV.isHidden { self.detailView.imagesSV.alpha = 1 }
            if !self.detailView.castSV.isHidden { self.detailView.castSV.alpha = 1 }
            if !self.detailView.similarSV.isHidden { self.detailView.similarSV.alpha = 1 }
        }
    }

    private func setDetailInfo(tvShow: TVShow) {

        self.tvShow = tvShow

        // Set detail info
        detailView.setDetailInfo(runtime: tvShow.episodeRuntime?.last,
                                 homepage: tvShow.homepage,
                                 lastAirDate: tvShow.lastAirDate,
                                 seasons: tvShow.seasons,
                                 episodes: tvShow.episodes)

        // Trailers
        if let videosResponse = tvShow.videos, !videosResponse.results.isEmpty {
            let filteredTrailers = videosResponse.results.filter { $0.site == "YouTube" }
            if !filteredTrailers.isEmpty {
                trailerDataSource = TrailerDataSource(trailers: filteredTrailers)
                detailView.trailersSV.isHidden = false
                detailView.trailersSV.alpha = 0
                detailView.trailersCV.delegate = self
                detailView.trailersCV.dataSource = trailerDataSource
            }
        }

        // Photos
        if let images = tvShow.images, !images.backdrops.isEmpty {
            let filteredBackgropImages = images.backdrops.filter { $0.aspect != nil && $0.filePath != nil }
            if !filteredBackgropImages.isEmpty {
                imageDataSource = ImageDataSource(images: filteredBackgropImages)
                detailView.imagesSV.isHidden = false
                detailView.imagesSV.alpha = 0
                detailView.imagesCV.delegate = self
                detailView.imagesCV.dataSource = imageDataSource
            }
        }

        // Cast
        if let credits = tvShow.credits, !credits.cast.isEmpty {
            castDataSource = CastDataSource(cast: credits.cast)
            detailView.castSV.isHidden = false
            detailView.castSV.alpha = 0
            detailView.castCV.delegate = self
            detailView.castCV.dataSource = castDataSource
        }

        // Similar
        if showSimilar, let similarResponse = tvShow.similar, !similarResponse.results.isEmpty {
            similarTVShowDataSource = SimilarTVShowDataSource(tvShows: similarResponse.results)
            detailView.similarSV.isHidden = false
            detailView.similarSV.alpha = 0
            detailView.similarCV.delegate = self
            detailView.similarCV.dataSource = similarTVShowDataSource
        }

        // FadeIn Animation
        UIView.animate(withDuration: 0.3) {
            if !self.detailView.seasonsLabel.isHidden { self.detailView.seasonsLabel.alpha = 1 }
            if !self.detailView.durationLabel.isHidden { self.detailView.durationLabel.alpha = 1 }
            if !self.detailView.homepageBtn.isHidden { self.detailView.homepageBtn.alpha = 1 }
            if !self.detailView.trailersSV.isHidden { self.detailView.trailersSV.alpha = 1 }
            if !self.detailView.imagesSV.isHidden { self.detailView.imagesSV.alpha = 1 }
            if !self.detailView.castSV.isHidden { self.detailView.castSV.alpha = 1 }
            if !self.detailView.similarSV.isHidden { self.detailView.similarSV.alpha = 1 }
        }
    }
}

// MARK: - Load detail data

extension MovieDetailVC {

    private func loadDetailData() {

        if let movie = movie {
            loadMovieDetail(id: movie.id)
        } else if let tvShow = tvShow {
            loadTVShowDetail(id: tvShow.id)
        }
    }

    private func loadMovieDetail(id: Int) {
        MovieAPI.shared.GET(endpoint: .movieDetail(id: id),
                            params: ["append_to_response": "credits,images,videos,similar", "include_image_language": "en,null"],
                             printDebug: false) { [weak self] (result: Result<Movie,MovieAPIError>) in
                                guard let self = self else { return }
                                switch result {
                                case .success(let movie): self.setDetailInfo(movie: movie)
                                case .failure(let error): print(error)
                                }
        }
    }

    private func loadTVShowDetail(id: Int) {
        MovieAPI.shared.GET(endpoint: .tvDetail(id: id),
                            params: ["append_to_response": "credits,images,videos,similar", "include_image_language": "en,null"],
                            printDebug: false) { [weak self] (result: Result<TVShow,MovieAPIError>) in
                                guard let self = self else { return }
                                switch result {
                                case .success(let tvShow): self.setDetailInfo(tvShow: tvShow)
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
        if scrollView == detailView.scrollView {
            disablePosterDragging = scrollView.contentOffset.y == 0 && detailView.scrollView.panGestureRecognizer.velocity(in: detailView.scrollView).y > 0
        } else {
            collectionViewDragging = true
        }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView != detailView.scrollView {
            collectionViewDragging = false
        }
        if !decelerate {
            scrollViewDidEndDecelerating(scrollView)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == detailView.scrollView {
            disablePosterDragging = false
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == detailView.scrollView {
            if !disablePosterDragging {
                let translationY = -scrollView.contentOffset.y //scrollIsDragging ? min(0, -scrollView.contentOffset.y) : -scrollView.contentOffset.y
                detailView.posterView.transform = CGAffineTransform(translationX: 0, y: translationY)
            } else {
                scrollView.contentOffset = CGPoint(x: 0, y: 0)
            }
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
        guard detailView.scrollView.contentOffset.y <= 0 else { return }
        if collectionViewDragging {
            gesture.isEnabled = false
            gesture.isEnabled = true
            detailView.visualEffectView.effect = detailView.blurEffect // bugfix - blur flickers on cancel
        }
        delegate?.handleGestureDismissTransition(gesture: gesture)
    }

    // Bugfix for interactor
    func disableScroll() {
        detailView.scrollView.panGestureRecognizer.isEnabled = false
    }

    func enableScroll() {
        detailView.scrollView.panGestureRecognizer.isEnabled = true
        detailView.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        detailView.visualEffectView.effect = detailView.blurEffect // bug fix - blur flickers on short gestures
    }
}


// MARK: - CollectionViewDelegate

extension MovieDetailVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        switch collectionView {

        case detailView.trailersCV:
            if let trailerDataSource = trailerDataSource, let item = trailerDataSource.item(at: indexPath.item) {
                delegate?.playYoutubeVideo(videoID: item.key)
            }

        case detailView.imagesCV:
            if let imageDataSource = imageDataSource {
                delegate?.imagesViewer(imageURLs: imageDataSource.imageURLs, firstIndex: indexPath.item)
            }

        case detailView.castCV:
            if let castDataSource = castDataSource {
                delegate?.imagesViewer(imageURLs: castDataSource.imageURLs, firstIndex: indexPath.item)
            }

        case detailView.similarCV:
            if let cell = collectionView.cellForItem(at: indexPath) as? PosterCell,
                let _ = cell.imageView.image {

                    if let similarMovieDataSource = similarMovieDataSource,
                    let movie = similarMovieDataSource.item(at: indexPath.item) {
                        delegate?.detail(movie: movie, posterCell: cell)
                    } else if let similarTVShowDataSource = similarTVShowDataSource,
                        let tvShow = similarTVShowDataSource.item(at: indexPath.item) {
                        delegate?.detail(tvShow: tvShow, posterCell: cell)
                    }
                }

        default: break
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {

        case detailView.trailersCV:
            return (detailView.trailersCV.collectionViewLayout as! UICollectionViewFlowLayout).itemSize

        case detailView.imagesCV:
            let height =  detailView.imagesCV.frame.height
            if let item = imageDataSource!.item(at: indexPath.item) {
                let width = height * CGFloat(item.aspect!)
                return CGSize(width: width, height: height)
            }
            return  CGSize(width: height, height: height)

        case detailView.castCV:
            return (detailView.castCV.collectionViewLayout as! UICollectionViewFlowLayout).itemSize

        case detailView.similarCV:
            return (detailView.similarCV.collectionViewLayout as! UICollectionViewFlowLayout).itemSize

        default: return .zero
        }
    }
}
