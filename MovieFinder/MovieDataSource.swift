//
//  MovieDataSource.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 22.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit
import Nuke

class MovieDataSource: NSObject, DataSourceProtocol {

    var delegate: DataSourceDelegate?

    // DataSourceProtocol
    var isLoadingData: Bool { get { return isFetching }}
    var isEmpty: Bool { get { return items.isEmpty }}

    private unowned var collectionView: UICollectionView
    
    private var page = 0
    private var totalPages = 0
    private var items = [Movie]()

    private var isFetching = false
    private var retryingToFetchData = false

    private var itemOnFocus = -1
    
    private var firstLoad = true
    
    private let preheater = ImagePreheater()

    private var movieFilter: MovieFilter = .popular
    var filter: MovieFilter {
        get {
            return movieFilter
        }
        set (newFilter) {
            movieFilter = newFilter
            fetchDataWithCurrentFilter()
        }
    }

    private weak var dataTask: URLSessionDataTask?

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        //loadWith(movieFilter: MovieFilter.upcoming) // loadWith(movieFilter: MovieFilter.search("Kill"))
    }

    func getItem(index: Int) -> Movie? {
        if index >= 0, index < items.count {
            return items[index]
        }
        return nil
    }

    private func fetchDataWithCurrentFilter() {
        itemOnFocus = -1
        page = 0
        totalPages = 0
        fetchData()
    }

    func tryToFetchMore(indexPath: IndexPath, itemsTreshold: Int) {
        if !isFetching,
            indexPath.item > max(0, items.count - 1 - itemsTreshold),
            page + 1 <= totalPages,
            items.count >= itemsTreshold {
            fetchData()
        }
    }

    private func fetchData() {

        var endpoint: MovieAPIEndpoint!
        let pageToLoad = page + 1
        var params = ["page": "\(pageToLoad)", "region": "US"]

        switch movieFilter {

        case .popular: endpoint = .moviePopular
        case .trending: endpoint = .movieTrending
        case .topRated: endpoint = .movieTopRated
        case .upcoming: endpoint = .movieUpcoming

        case .genres(let genres):
            endpoint = .movieDiscover
            params["with_genres"] = genres.map { String($0.id) }.joined(separator: ",")

        case .search(let searchTerm):
            endpoint = .movieSearch
            params["query"] = searchTerm
        }

        isFetching = true
        retryingToFetchData = false
        if pageToLoad == 1 { delegate?.dataIsLoading() }
        dataTask?.cancel()
        dataTask = MovieAPI.shared.GET(endpoint: endpoint,
                                 params: params,
                                 printDebug: false) { [weak self] (result: Result<MovieResponse, MovieAPIError>) in
    
                                    guard let self = self else { return }
                                    self.isFetching = false

                                    switch result {
                                    case .success(let response):
                                        
                                        self.page = response.page
                                        self.totalPages = response.totalPages

                                        // Ignore results without posters - not cool
                                        let results = response.results.filter { $0.posterPath != nil }

                                        // First load with new filter
                                        if self.page == 1, !self.items.isEmpty {
                                            self.items.removeAll()
                                            self.collectionView.reloadData()
                                        }

                                        self.collectionView.performBatchUpdates({

                                            self.items.append(contentsOf: results)
                                            var insertedItemsIndex = [IndexPath]()
                                            let end = self.items.count
                                            let start = end - results.count
                                            for i in start..<end {
                                                insertedItemsIndex.append(IndexPath(item: i, section: 0))
                                            }
                                            self.collectionView.insertItems(at: insertedItemsIndex)
                                        }, completion: nil)

                                        if self.itemOnFocus == -1 && !self.items.isEmpty {
                                            self.itemOnFocus = 0
                                            self.callOnFocusDelegate()
                                        }

                                        if self.page == 1 {
                                            self.delegate?.dataLoaded()
                                        }

                                    case .failure(_):
                                        self.retryFetchData()
                                    }
            }
    }

    private func retryFetchData() { // on unsuccessful request
        if !retryingToFetchData {
            retryingToFetchData = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                if let self = self { self.fetchData() }
            }
        }
    }

    private func callOnFocusDelegate() {

        if itemOnFocus < items.count {
            let item = items[itemOnFocus]
            var posterURL: URL? = nil
            if  let posterPath = item.posterPath {
                posterURL = MovieImagePath.medium.path(poster: posterPath)
            }

            delegate?.itemOnFocus(name: item.title, voteAverage: item.voteAverage, genres: GenresData.movieGenreNames(ids: item.genreIds), year: item.releaseDate, imageURL: posterURL)
        }
      }
    
    private func imageURLForPosterPath(_ path: String) -> URL {
        if let _ = collectionView.collectionViewLayout as? CoverFlowLayout {
            return MovieImagePath.medium.path(poster: path)
        }
        return MovieImagePath.small.path(poster: path)
    }
}

extension MovieDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let _ = collectionView.collectionViewLayout as? CoverFlowLayout {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterBigCell.reuseIdentifier, for: indexPath) as! PosterBigCell
            if let posterPath = items[indexPath.item].posterPath {
                cell.loadImage(imageURL: imageURLForPosterPath(posterPath))
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterSmallCell.reuseIdentifier, for: indexPath) as! PosterSmallCell
        let item = items[indexPath.item]
        cell.title.text = item.title
        cell.genres.text = GenresData.movieGenreNames(ids: item.genreIds).joined(separator: ", ")
        if let rating = item.voteAverage, rating != 0.0 {
            cell.rating.text = String(rating)
            cell.rating.isHidden = false
        } else {
            cell.rating.isHidden = true
        }
        if let posterPath = item.posterPath {
            cell.loadImage(imageURL: imageURLForPosterPath(posterPath))
        }
        return cell
    }
}

extension MovieDataSource: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        var urls = [URL]()
        let itemsCount = items.count
        for indexPath in indexPaths {
            if indexPath.item < itemsCount,
                let posterPath = items[indexPath.item].posterPath {
                urls.append(imageURLForPosterPath(posterPath))
            }
        }
        preheater.startPreheating(with: urls)
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        var urls = [URL]()
        let itemsCount = items.count
        for indexPath in indexPaths {
            if indexPath.item < itemsCount,
                let posterPath = items[indexPath.item].posterPath {
                urls.append(imageURLForPosterPath(posterPath))
            }
        }
        preheater.stopPreheating(with: urls)
    }
}

extension MovieDataSource: CoverFlowLayoutDelegate {
    
    func coverFlowFocused(pageIndex: Int) {
        
        let itemOnFocus = max(0, min(items.count-1, pageIndex))
        if self.itemOnFocus != itemOnFocus {
            self.itemOnFocus = itemOnFocus
            callOnFocusDelegate()
        }
    }
}
