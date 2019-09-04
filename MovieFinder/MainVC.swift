//
//  MainVC.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    let mainView = MainView()

    private var section: MovieSection = .movies

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
        mainView.sectionLabel.text = "movies".localized
        mainView.filterLabel.text = "top_rated".localized
        
        // Default data source(Movies)
        movieDataSource = MovieDataSource(collectionView: mainView.collectionView)
        movieDataSource.delegate = self

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
        
        // Set info
        mainView.setInfo(name: name, rating: voteAverage, genres: genres, date: year)
    }
}
