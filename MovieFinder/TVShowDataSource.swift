//
//  TVShowDataSource.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 16.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit
import Nuke

class TVShowDataSource: NSObject, DataSourceProtocol {

    var delegate: DataSourceDelegate?

    // DataSourceProtocol
    var isLoadingData: Bool { get { return isFetching }}
    var isEmpty: Bool { get { return items.isEmpty }}

    private unowned var collectionView: UICollectionView

    private var page = 0
    private var totalPages = 0
    private var items = [TVShow]()

    private var isFetching = false
    private var retryingToFetchData = false

    private var itemOnFocus = -1

    private var firstLoad = true

    private let preheater = ImagePreheater()

    private var tvShowFilter: TVShowFilter = TVShowFilter.list[0]
    var filter: TVShowFilter {
        get {
            return tvShowFilter
        }
        set (newFilter) {
            tvShowFilter = newFilter
            fetchDataWithCurrentFilter()
        }
    }

    private var dataSourceIsOnFocus: Bool {
        get {
            return delegate != nil
        }
    }

    private weak var dataTask: URLSessionDataTask?

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }

    func getItem(index: Int) -> TVShow? {
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

        switch tvShowFilter {

        case .popular: endpoint = .tvPopular
        case .trending: endpoint = .tvTrending
        case .topRated: endpoint = .tvTopRated
        case .onTheAir: endpoint = .tvOnTheAir

        case .genres(let genres):
            endpoint = .tvDiscover
            params["with_genres"] = genres.map { String($0.id) }.joined(separator: ",")

        case .search(let searchTerm):
            endpoint = .tvSearch
            params["query"] = searchTerm
        }

        isFetching = true
        retryingToFetchData = false
        if pageToLoad == 1 { delegate?.dataIsLoading() }
        dataTask?.cancel()
        dataTask = MovieAPI.shared.GET(endpoint: endpoint,
                                       params: params,
                                       printDebug: false) { [weak self] (result: Result<TVShowResponse, MovieAPIError>) in

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
                                                if self.dataSourceIsOnFocus {
                                                    self.collectionView.reloadData()
                                                }
                                            }

                                            if self.dataSourceIsOnFocus {
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
                                            } else {
                                                self.items.append(contentsOf: results)
                                            }

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

        if itemOnFocus >= 0, itemOnFocus < items.count {
            let item = items[itemOnFocus]
            var posterURL: URL? = nil
            if  let posterPath = item.posterPath {
                posterURL = MovieImagePath.large.path(poster: posterPath)
            }

            delegate?.itemOnFocus(name: item.title, voteAverage: item.voteAverage, genres: GenresData.movieGenreNames(ids: item.genreIDs), year: item.firstAirDate, imageURL: posterURL)
        }
    }

    func updateItemOnFocus() {
        if let coverFlowLayout = collectionView.collectionViewLayout as? CoverFlowLayout,
            let focusedIndexPath = coverFlowLayout.getFocused() {
            itemOnFocus = focusedIndexPath.item
            callOnFocusDelegate()
        }
    }

    private func imageURLForPosterPath(_ path: String) -> URL {
        if let _ = collectionView.collectionViewLayout as? CoverFlowLayout {
            return UIDevice.current.userInterfaceIdiom == .pad ? MovieImagePath.xlarge.path(poster: path) : MovieImagePath.large.path(poster: path)
        }
        return UIDevice.current.userInterfaceIdiom == .pad ?  MovieImagePath.large.path(poster: path) : MovieImagePath.medium.path(poster: path)
    }
}

extension TVShowDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = items[indexPath.item]
        var itemPosterURL: URL?
        if let posterPath = item.posterPath {
            itemPosterURL = imageURLForPosterPath(posterPath)
        }

        // Big Poster Cell
        if let _ = collectionView.collectionViewLayout as? CoverFlowLayout {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterBigCell.reuseIdentifier, for: indexPath) as! PosterBigCell
            if let itemPosterURL = itemPosterURL {
                cell.loadImage(imageURL: itemPosterURL)
            }
            return cell
        }

        // Small poster cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterSmallCell.reuseIdentifier, for: indexPath) as! PosterSmallCell
        cell.setData(title: item.title, genreNames: GenresData.movieGenreNames(ids: item.genreIDs), rating: item.voteAverage, posterURL: itemPosterURL)
        return cell
    }
}

extension TVShowDataSource: UICollectionViewDataSourcePrefetching {

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

extension TVShowDataSource: CoverFlowLayoutDelegate {

    func coverFlowFocused(pageIndex: Int) {

        let itemOnFocus = max(0, min(items.count-1, pageIndex))
        if self.itemOnFocus != itemOnFocus {
            self.itemOnFocus = itemOnFocus
            callOnFocusDelegate()
        }
    }
}
