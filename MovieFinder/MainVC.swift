//
//  MainVC.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    weak var delegate: MainCoordinatorDelegate?
    
    let mainView = MainView()

    private var section: MovieSection = .movies // Default

    // Data Sources for collection view(Movies, TV Shows and Favourites)
    private var movieDataSource: MovieDataSource!
    private var tvDataSource: TVShowDataSource!
    private var favouriteDataSource: FavouriteDataSource!
    
    private var firstTimeDataLoading = true

    private var hideKeyboardOnTap: UITapGestureRecognizer?
    private var movieSearchTerm = ""
    private var tvShowsSearchTerm = ""
    private let searchThrottler = Throttler(minimumDelay: 0.5)

    private let hideFilterMenuOnChange = false

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGenres()

//        // Test code - go to movie details
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
//            guard let self = self else { return }
//            let indexPath = IndexPath(item: 0, section: 0)
//            if let cell = self.mainView.collectionView.cellForItem(at: indexPath) as? PosterCell,
//                let _ = cell.imageView.image {
//                switch self.section {
//                case .movies:
//                    if let movie = self.movieDataSource.getItem(index: indexPath.item) {
//                        self.delegate?.detail(movie: movie, posterCell: cell)
//                    }
//                case .tvShows:
//                    if let tvShow = self.tvDataSource.getItem(index: indexPath.item) {
//                        self.delegate?.detail(tvShow: tvShow, posterCell: cell)
//                    }
//                default: break
//                }
//            }
//        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        mainView.constraintCollectionView()
    }

    override func loadView() {
        view = mainView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.updateItemSize()
    }

    private func loadGenres() {

        GenresData.loadGenres { [weak self] (result) in
            
            guard let self = self else { return }
            switch result {
            case .success(_): self.setupVC()
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { self.loadGenres() })
            }
        }
    }

    private func setupVC() {

        // Button actions
        setupActions()

        // Setup SearchField
        setupSearchField()

        // CollectionView setup
        mainView.collectionView.delegate = self

        // Create data sources
        movieDataSource = MovieDataSource(collectionView: mainView.collectionView)
        tvDataSource = TVShowDataSource(collectionView: mainView.collectionView)
        favouriteDataSource = FavouriteDataSource(collectionView: mainView.collectionView)

        // Set default section
        selectSection(section: section)

        // Load with default filters(After selectSection!)
        movieDataSource.filter = movieDataSource.filter
        tvDataSource.filter = tvDataSource.filter
        favouriteDataSource.filter = favouriteDataSource.filter
    }

    private func selectSection(section: MovieSection) {

        self.section = section

        movieDataSource.delegate = nil
        tvDataSource.delegate = nil
        favouriteDataSource.delegate = nil

        switch section {
        case .movies:
            mainView.collectionView.contentOffset = .zero
            (mainView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.invalidateLayout()
            mainView.coverFlowLayout.delegate = movieDataSource
            mainView.collectionView.dataSource = movieDataSource
            mainView.collectionView.prefetchDataSource = movieDataSource
            movieDataSource.delegate = self
            if !firstTimeDataLoading {
                mainView.collectionView.isUserInteractionEnabled = !movieDataSource.isLoadingData
                mainView.collectionView.alpha = movieDataSource.isLoadingData ? 0.5 : 1.0
                movieDataSource.updateItemOnFocus()
            }

        case .tvShows:
            mainView.collectionView.contentOffset = .zero
            (mainView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.invalidateLayout()
            mainView.coverFlowLayout.delegate = tvDataSource
            mainView.collectionView.dataSource = tvDataSource
            mainView.collectionView.prefetchDataSource = tvDataSource
            mainView.collectionView.contentOffset = .zero
            tvDataSource.delegate = self
            if !firstTimeDataLoading {
                mainView.collectionView.isUserInteractionEnabled = !tvDataSource.isLoadingData
                mainView.collectionView.alpha = tvDataSource.isLoadingData ? 0.5 : 1.0
                tvDataSource.updateItemOnFocus()
            }

        case .favourites:
            mainView.collectionView.contentOffset = .zero
            (mainView.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.invalidateLayout()
            mainView.coverFlowLayout.delegate = favouriteDataSource
            mainView.collectionView.dataSource = favouriteDataSource
            mainView.collectionView.prefetchDataSource = favouriteDataSource
            favouriteDataSource.delegate = self
            if !firstTimeDataLoading {
                mainView.collectionView.isUserInteractionEnabled = !favouriteDataSource.isLoadingData
                mainView.collectionView.alpha = favouriteDataSource.isLoadingData ? 0.5 : 1.0
                favouriteDataSource.updateItemOnFocus()
            }
        }

        if !firstTimeDataLoading, let dataSource =  mainView.collectionView.dataSource as? DataSourceProtocol {
            mainView.noResultFoundView.isHidden = !dataSource.isEmpty
        }

        if let dataSource = mainView.collectionView.dataSource as? DataSourceProtocol, dataSource.isEmpty {
            mainView.setInfo(name: "noResultFound".localized, rating: nil, genres: [], date: nil)
        }

        updateFilterOptions()
        updateFilterField()
        mainView.filterView.selectSection(section: section)
    }

    private func updateFilterField() {

        switch section {
        case .movies:
            switch movieDataSource.filter {
            case .search(let searchTerm): mainView.filterLabel.text = "\(movieDataSource.filter.localizedName): \(searchTerm)"
            case .genres(let genres): self.mainView.filterLabel.text = "\(movieDataSource.filter.localizedName): \(genres.map { $0.name }.joined(separator: ", "))"
            default: mainView.filterLabel.text = movieDataSource.filter.localizedName
            }

        case .tvShows:
            switch tvDataSource.filter {
            case .search(let searchTerm): mainView.filterLabel.text = "\(tvDataSource.filter.localizedName): \(searchTerm)"
            case .genres(let genres): self.mainView.filterLabel.text = "\(tvDataSource.filter.localizedName): \(genres.map { $0.name }.joined(separator: ", "))"
            default: mainView.filterLabel.text = tvDataSource.filter.localizedName
            }

        case .favourites:
            mainView.filterLabel.text = favouriteDataSource.filter.localizedName
        }
    }

    private func updateFilterOptions() {

        mainView.sectionLabel.text = section.localizedName
        updateFilterField()

        switch section {
        case .movies:
            let filterNames: [String] = MovieFilter.list.map { $0.localizedName }
            mainView.filterView.setFilters(names: filterNames, selectIndex: movieDataSource.filter.index)

        case .tvShows:
            let filterNames: [String] = TVShowFilter.list.map { $0.localizedName }
            mainView.filterView.setFilters(names: filterNames, selectIndex: tvDataSource.filter.index)

        case .favourites:
            let filterNames: [String] = FavouriteFilter.list.map { $0.localizedName }
            mainView.filterView.setFilters(names: filterNames, selectIndex: favouriteDataSource.filter.index)
        }
    }

    private func selectMovieFilter(index: Int, skipHideFilter: Bool = false) {

        let filter = MovieFilter.list[index]

        switch filter {

        case .genres(_):
            var selectedGenres: [Genre] = []
            if case MovieFilter.genres(let genres) = movieDataSource.filter {
                selectedGenres = genres
            }
            delegate?.pickGenres(genreType: .movie, completion: { [weak self] (selectedGenres) in

                guard let self = self else { return }

                switch self.movieDataSource.filter {
                case .genres(_):
                    if selectedGenres.isEmpty {
                        self.selectMovieFilter(index: 0)
                        return
                    }
                default: break
                }

                if !selectedGenres.isEmpty {
                    let genresFilter = MovieFilter.genres(selectedGenres)
                    self.movieDataSource.filter = genresFilter
                    self.mainView.filterView.selectFilter(selectIndex: genresFilter.index)
                    self.updateFilterField()
                    if self.hideFilterMenuOnChange, !skipHideFilter {
                        self.mainView.hideFilter()
                    }
                }
                }, selected: selectedGenres)


        case .search(_):
            if case MovieFilter.search(_) = movieDataSource.filter {} else {
                movieSearchTerm = ""
                mainView.searchView.searchField.text = ""
            }
            mainView.searchView.searchField.becomeFirstResponder()
            break

        default:

            movieDataSource.filter = filter
            updateFilterField()
            mainView.filterView.selectFilter(selectIndex: index)
            if hideFilterMenuOnChange, !skipHideFilter {
                mainView.hideFilter()
            }
        }
    }

    private func selectTVShowFilter(index: Int, skipHideFilter: Bool = false) {

        let filter = TVShowFilter.list[index]

        switch filter {

        case .genres(_):
            var selectedGenres: [Genre] = []
            if case TVShowFilter.genres(let genres) = tvDataSource.filter {
                selectedGenres = genres
            }
            delegate?.pickGenres(genreType: .tvShow, completion: { [weak self] (selectedGenres) in

                guard let self = self else { return }

                switch self.tvDataSource.filter {
                case .genres(_):
                    if selectedGenres.isEmpty {
                        self.selectTVShowFilter(index: 0)
                        return
                    }
                default: break
                }

                if !selectedGenres.isEmpty {
                    let genresFilter = TVShowFilter.genres(selectedGenres)
                    self.tvDataSource.filter = genresFilter
                    self.mainView.filterView.selectFilter(selectIndex: genresFilter.index)
                    self.updateFilterField()
                    if self.hideFilterMenuOnChange, !skipHideFilter {
                        self.mainView.hideFilter()
                    }
                }
                }, selected: selectedGenres)


        case .search(_):
            if case TVShowFilter.search(_) = tvDataSource.filter {} else {
                tvShowsSearchTerm = ""
                mainView.searchView.searchField.text = ""
            }
            mainView.searchView.searchField.becomeFirstResponder()
            break

        default:

            tvDataSource.filter = filter
            updateFilterField()
            mainView.filterView.selectFilter(selectIndex: index)
            if hideFilterMenuOnChange, !skipHideFilter {
                mainView.hideFilter()
            }
        }
    }

    private func selectFavouriteFilter(index: Int) {

        favouriteDataSource.filter = FavouriteFilter.list[index]
        updateFilterField()
        mainView.filterView.selectFilter(selectIndex: index)
        if hideFilterMenuOnChange { mainView.hideFilter()  }
    }
}


// MARK: - Actions

extension MainVC {

    private func setupActions() {
        mainView.scrollToTopBtn.addTarget(self, action: #selector(scrollToTopAction), for: .touchUpInside)
        mainView.toggleLayoutBtn.addTarget(self, action: #selector(toggleLayoutAction), for: .touchUpInside)
        mainView.filtersBtn.addTarget(self, action: #selector(showFilterAction), for: .touchUpInside)
        mainView.filterView.hideFilterBtn.addTarget(self, action: #selector(hideFilterAction), for: .touchUpInside)
        for filterBtn in mainView.filterView.filterBtns {
            filterBtn.addTarget(self, action: #selector(filterAction), for: .touchUpInside)
        }
        mainView.filterView.moviesBtn.addTarget(self, action: #selector(sectionAction), for: .touchUpInside)
        mainView.filterView.tvShowsBtn.addTarget(self, action: #selector(sectionAction), for: .touchUpInside)
        mainView.filterView.favouritesBtn.addTarget(self, action: #selector(sectionAction), for: .touchUpInside)
    }

    @objc private func scrollToTopAction(_ sender: Any) {
        mainView.scrollToTop()
    }
    
    @objc private func toggleLayoutAction(_ sender: Any) {
        mainView.collectionViewToggleLayout()
    }
    
    @objc private func showFilterAction(_ sender: Any) {
        mainView.showFilter()
    }

    @objc private func hideFilterAction(_ sender: Any) {
        mainView.hideFilter()
    }

    @objc private func sectionAction(_ sender: UIButton) {

        switch sender.tag {
        case 0: if section != .movies { selectSection(section: .movies) }
        case 1: if section != .tvShows { selectSection(section: .tvShows) }
        case 2: if section != .favourites { selectSection(section: .favourites) }
        default: break
        }
    }

    @objc private func filterAction(_ sender: UIButton) {
        switch section {
        case .movies: selectMovieFilter(index: sender.tag)
        case .tvShows: selectTVShowFilter(index: sender.tag)
        case .favourites: selectFavouriteFilter(index: sender.tag)
        }
    }
}

// MARK: - Soft Keyboard

extension MainVC {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
        hideKeyboardOnTap = gesture
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        if let gesture = hideKeyboardOnTap {
            view.removeGestureRecognizer(gesture)
            hideKeyboardOnTap = nil
        }
    }

    @objc private func keyboardNotification(notification: Notification) {

        if notification.name == UIResponder.keyboardWillShowNotification { // Show search bar
            mainView.collectionView.isUserInteractionEnabled = false
            mainView.searchView.isHidden = false
            mainView.searchView.alpha = 1
        } else if notification.name == UIResponder.keyboardWillHideNotification { // Hide searchBar
            mainView.searchView.isHidden = true
            mainView.searchView.alpha = 0
            mainView.collectionView.isUserInteractionEnabled = !(mainView.collectionView.dataSource as! DataSourceProtocol).isLoadingData
            if hideFilterMenuOnChange {
                mainView.hideFilter()
            }
        }
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            mainView.searchView.transform = CGAffineTransform(translationX: 0, y: -keyboardRect.height)
        } else {
            mainView.searchView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Search Field

extension MainVC: UITextFieldDelegate {

    private func setupSearchField() {
        mainView.searchView.searchField.addTarget(self, action: #selector(searchFieldDidChange), for: .editingChanged)
        mainView.searchView.searchField.delegate = self
    }

    @objc func searchFieldDidChange() {

        let searchField = mainView.searchView.searchField
        let searchTerm = searchField?.text ?? ""

        switch section {
        case .movies:
            if searchTerm != movieSearchTerm {
                movieSearchTerm = searchTerm
                if movieSearchTerm.isEmpty {
                    selectMovieFilter(index: 0, skipHideFilter: true)
                } else {
                    searchThrottler.throttle { [weak self] in
                        guard let self = self else { return }
                        let searchFilter = MovieFilter.search(self.movieSearchTerm)
                        self.mainView.filterView.selectFilter(selectIndex: searchFilter.index)
                        self.movieDataSource.filter = searchFilter
                        self.updateFilterField()
                    }
                }
            }

        case .tvShows:
            if searchTerm != tvShowsSearchTerm {
                tvShowsSearchTerm = searchTerm
                if tvShowsSearchTerm.isEmpty {
                    selectTVShowFilter(index: 0, skipHideFilter: true)
                } else {
                    searchThrottler.throttle { [weak self] in
                        guard let self = self else { return }
                        let searchFilter = TVShowFilter.search(self.tvShowsSearchTerm)
                        self.mainView.filterView.selectFilter(selectIndex: searchFilter.index)
                        self.tvDataSource.filter = searchFilter
                        self.updateFilterField()
                    }
                }
            }

        default: break
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}

// MARK: - Collection View Delegate

extension MainVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return mainView.collectionViewInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)

        if let cell = collectionView.cellForItem(at: indexPath) as? PosterCell,
            let _ = cell.imageView.image {

            switch section {
            case .movies:
                if let movie = movieDataSource.getItem(index: indexPath.item) {
                    delegate?.detail(movie: movie, posterCell: cell, fromFavourite: false)
                }
            case .tvShows:
                if let tvShow = tvDataSource.getItem(index: indexPath.item) {
                    delegate?.detail(tvShow: tvShow, posterCell: cell, fromFavourite: false)
                }
            case .favourites:
                let item = favouriteDataSource.getItem(index: indexPath.item)
                if let movie = item as? Movie {
                    delegate?.detail(movie: movie, posterCell: cell, fromFavourite: true)
                } else if let tvShow = item as? TVShow {
                    delegate?.detail(tvShow: tvShow, posterCell: cell, fromFavourite: true)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if mainView.isFilterHidden {
            if mainView.collectionView.contentOffset.x > 0 {
                  mainView.scrollToTopBtn.alpha = 1
            } else {
                  mainView.scrollToTopBtn.alpha = mainView.scrollToTopBtnAlpha
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let fetchMoreItemsTreshold = mainView.isCoverFlowLayout ? 5 :  10
        switch section {
        case .movies: movieDataSource.tryToFetchMore(indexPath: indexPath, itemsTreshold: fetchMoreItemsTreshold)
        case .tvShows: tvDataSource.tryToFetchMore(indexPath: indexPath, itemsTreshold: fetchMoreItemsTreshold)
        default: break
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        mainView.hideInfo()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        mainView.showInfo()
    }
}

// MARK: - DataSourceDelegate

extension MainVC: DataSourceDelegate {

    func dataIsLoading() {
        if !firstTimeDataLoading {
            mainView.collectionView.isUserInteractionEnabled = false
            mainView.collectionView.alpha = 0.5
        }
    }

    func dataLoaded() {
        let dataSource = mainView.collectionView.dataSource as! DataSourceProtocol
        if dataSource.isEmpty {
            mainView.noResultFoundView.isHidden = false
            mainView.setInfo(name: "noResultFound".localized, rating: nil, genres: [], date: nil)
        } else if !firstTimeDataLoading {
            mainView.collectionView.isUserInteractionEnabled = mainView.searchView.isHidden
            mainView.collectionView.alpha = 1
            mainView.noResultFoundView.isHidden = true
        }

        // On App Launch after load data
        if firstTimeDataLoading {
            firstTimeDataLoading = false
            mainView.showViewsAfterLoadingDataOnAppLaunch()
        }

        mainView.scrollToTopBtn.alpha = mainView.scrollToTopBtnAlpha
    }

    func itemOnFocus(name: String, voteAverage: Double?, genres: [String], year: String?, imageURL: URL?) {
        if let imageURL = imageURL {
            mainView.backgroundView.loadImage(url: imageURL)
        }
        mainView.setInfo(name: name, rating: voteAverage, genres: genres, date: year)
    }
}
