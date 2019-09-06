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

    private var section: MovieSection = .movies

    // Data Sources for collection view(Movies, TV Shows and Favourites)
    private var movieDataSource: MovieDataSource!
    // private var tvDataSource: TVDataSource!
    // private var favouritesDataSource: FavouritesDataSource!s
    
    private var firstTimeDataLoaded = false

    private var hideKeyboardOnTap: UITapGestureRecognizer?
    private var movieSearchTerm = ""
    private var tvShowsSearchTerm = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadGenres()
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

        // Default filters
        let movieFilter = MovieFilter.all[0]

        // Header (section & filter labels)
        mainView.sectionLabel.text = section.localizedName
        mainView.filterLabel.text = movieFilter.localizedName

        // Set filter
        let filterNames: [String] = MovieFilter.all.map { $0.localizedName }
        mainView.filterView.setFilters(names: filterNames, selectIndex: 0)

        // Default data source(Movies)
        movieDataSource = MovieDataSource(collectionView: mainView.collectionView)
        movieDataSource.delegate = self
        movieDataSource.filter = movieFilter

        // CollectionView setup
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = movieDataSource
        mainView.collectionView.prefetchDataSource = movieDataSource
        mainView.coverFlowLayout.delegate = movieDataSource
        
        // Button actions
        mainView.scrollToTopBtn.addTarget(self, action: #selector(scrollToTopAction), for: .touchUpInside)
        mainView.toggleLayoutBtn.addTarget(self, action: #selector(toggleLayoutAction), for: .touchUpInside)
        mainView.filtersBtn.addTarget(self, action: #selector(showFilterAction), for: .touchUpInside)
        mainView.filterView.hideFilterBtn.addTarget(self, action: #selector(hideFilterAction), for: .touchUpInside)
        for filterBtn in mainView.filterView.filterBtns {
            filterBtn.addTarget(self, action: #selector(filterAction), for: .touchUpInside)
        }

        // Setup SearchField
        setupSearchField()
    }

    private func selectMovieFilter(index: Int) {

        let filter = MovieFilter.all[index]

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
                    let genreNameString = selectedGenres.map { $0.name }.joined(separator: ", ")
                    self.mainView.filterLabel.text = "\(genresFilter.localizedName): \(genreNameString)"
                    self.mainView.filterView.selectFilter(selectIndex: genresFilter.index)
                    self.movieDataSource.filter = genresFilter
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

            mainView.filterLabel.text = filter.localizedName
            mainView.filterView.selectFilter(selectIndex: index)
            movieDataSource.filter = filter
        }
    }
}


// MARK: - Actions

extension MainVC {
    
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

    @objc private func filterAction(_ sender: UIButton) {
        switch section {
        case .movies: selectMovieFilter(index: sender.tag)
        case .tvShows: print("TV Shows Filter: \(sender.tag)")
        case .favourites: print("Favourites Filter: \(sender.tag)")
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
                    selectMovieFilter(index: 0)
                } else {
                    let searchFilter = MovieFilter.search(movieSearchTerm)
                    self.mainView.filterLabel.text = "\(searchFilter.localizedName): \(movieSearchTerm)"
                    self.mainView.filterView.selectFilter(selectIndex: searchFilter.index)
                    self.movieDataSource.filter = searchFilter
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

        if let cell = collectionView.cellForItem(at: indexPath) as? PosterCell, let image = cell.imageView.image {

            switch section {
            case .movies:
                if let movie = movieDataSource.getItem(index: indexPath.item) {
                    delegate?.detail(movie: movie, posterCell: cell)
                }

            default: break
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if mainView.isFilterHidden {
            if mainView.collectionView.contentOffset.x >= mainView.collectionView.bounds.width {
                  mainView.scrollToTopBtn.alpha = 1
            } else {
                  mainView.scrollToTopBtn.alpha = mainView.scrollToTopBtnAlpha
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let fetchMoreItemsTreshold = mainView.isCoverFlowLayout ? 5 :  10
        movieDataSource.tryToFetchMore(indexPath: indexPath, itemsTreshold: fetchMoreItemsTreshold)
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
        mainView.collectionView.isUserInteractionEnabled = false
        mainView.collectionView.alpha = 0.5
    }

    func dataLoaded() {
        // On App Launch after load data
        if !firstTimeDataLoaded {
            firstTimeDataLoaded = true
            mainView.showViewsAfterLoadingDataOnAppLaunch()
        }
        let dataSource = mainView.collectionView.dataSource as! DataSourceProtocol
        if dataSource.isEmpty {
            mainView.noResultFoundView.isHidden = false
            mainView.setInfo(name: "", rating: nil, genres: [], date: nil)
        } else {
            mainView.collectionView.isUserInteractionEnabled = true
            mainView.collectionView.alpha = 1
            mainView.noResultFoundView.isHidden = true
        }
    }

    func itemOnFocus(name: String, voteAverage: Double?, genres: [String], year: String?, imageURL: URL?) {
        if let imageURL = imageURL {
            mainView.backgroundView.loadImage(url: imageURL)
        }
        mainView.setInfo(name: name, rating: voteAverage, genres: genres, date: year)
    }
}
