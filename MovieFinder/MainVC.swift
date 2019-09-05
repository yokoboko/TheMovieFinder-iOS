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
    private var movieFilter: MovieFilter = MovieFilter.all[0]

    // Data Sources for collection view(Movies, TV Shows and Favourites)
    private var movieDataSource: MovieDataSource!
    
    private var dataLoaded = false
    
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
        
        // Header
        mainView.sectionLabel.text = section.localizedName
        mainView.filterLabel.text = movieFilter.localizedName

        // Set filter
        let filterNames: [String] = MovieFilter.all.map { $0.localizedName }
        mainView.filterView.setFilters(names: filterNames, selectIndex: 0)

        // Default data source(Movies)
        movieDataSource = MovieDataSource(collectionView: mainView.collectionView)
        movieDataSource.delegate = self
        movieDataSource.loadWith(movieFilter: movieFilter)

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
        case .movies:
                let filter = MovieFilter.all[sender.tag]

                switch filter {
                case .genres(_): break
                case .search(_): break
                default:
                    movieFilter = filter
                    mainView.filterLabel.text = movieFilter.localizedName
                    mainView.filterView.selectFilter(selectIndex: sender.tag)
                    movieDataSource.loadWith(movieFilter: movieFilter)

                    // Disable collectionView
                    mainView.collectionView.isUserInteractionEnabled = false
                    mainView.collectionView.alpha = 0.5
                }

        case .tvShows:
            print("TV Shows Filter: \(sender.tag)")

        case .favourites:
            print("Favourites Filter: \(sender.tag)")
        }
    }
}

// MARK: - Filters

extension MainVC {

}

// MARK: - Collection View Delegate

extension MainVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return mainView.collectionViewInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
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


extension MainVC: DataSourceDelegate {
    
    func movieOnFocus(name: String, voteAverage: Double?, genres: [String], year: String?, imageURL: URL?) {
        
        // On App Launch after load data
        if !dataLoaded {
            dataLoaded = true
            mainView.showViewsAfterLoadingDataOnAppLaunch()
        }
        
        // Load background image
        if let imageURL = imageURL {
            mainView.backgroundView.loadImage(url: imageURL)
        }

        // Enable collectionView
        mainView.collectionView.isUserInteractionEnabled = true
        mainView.collectionView.alpha = 1
        
        // Set info
        mainView.setInfo(name: name, rating: voteAverage, genres: genres, date: year)
    }
}
