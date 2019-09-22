//
//  FavouriteDataSource.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 19.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit
import Nuke

class FavouriteDataSource: NSObject, DataSourceProtocol {

    var delegate: DataSourceDelegate?

    // DataSourceProtocol
    var isLoadingData: Bool { get { return false }}
    var isEmpty: Bool {
        get {
            if favouriteFilter == .all {
                return items.isEmpty
            }
            return filteredItems.isEmpty
        }
    }

    private unowned var collectionView: UICollectionView

    private var items: [Any]
    private var filteredItems = [Any]()

    private var itemOnFocus = -1

    private let preheater = ImagePreheater()

    private var favouriteFilter: FavouriteFilter = FavouriteFilter.list[0]
    var filter: FavouriteFilter {
        get {
            return favouriteFilter
        }
        set (newFilter) {
            favouriteFilter = newFilter
            fetchDataWithCurrentFilter()
        }
    }

    private var dataSourceIsOnFocus: Bool {
        get {
            return delegate != nil
        }
    }

    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.items = CoreDataManager.shared.getFavourites().reversed()
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(onFavouriteAdded(_:)),
                                               name: .favouriteAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onFavouriteDeleted(_:)),
                                               name: .favouriteDeleted, object: nil)
    }

    @objc func onFavouriteAdded(_ notification:Notification) {

        if let object = notification.object {
            delegate?.dataIsLoading()
            items.insert(object, at: 0)
            if favouriteFilter == .movies, let _ = object as? Movie {
                filteredItems.insert(object, at: 0)
            } else if favouriteFilter == .tvShows, let _ = object as? TVShow {
                filteredItems.insert(object, at: 0)
            }
            if dataSourceIsOnFocus {
                collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
            }
            delegate?.dataLoaded()
            updateItemOnFocus()
        }
    }

    @objc func onFavouriteDeleted(_ notification:Notification) {
        if let object = notification.object {
            delegate?.dataIsLoading()
            for (index, item) in items.enumerated() {
                if let movie = item as? Movie, let deletedMovie = object as? Movie {
                    if movie.id == deletedMovie.id {
                        items.remove(at: index)
                        if dataSourceIsOnFocus, favouriteFilter == .all {
                            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                        }
                        break
                    }
                } else if let tvShow = item as? TVShow, let deletedTVShow = object as? TVShow {
                    if tvShow.id == deletedTVShow.id {
                        items.remove(at: index)
                        if dataSourceIsOnFocus, favouriteFilter == .all {
                            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                        }
                        break
                    }
                }
            }

            if favouriteFilter != .all {
                for (index, item) in filteredItems.enumerated() {
                    if let movie = item as? Movie, let deletedMovie = object as? Movie {
                        if movie.id == deletedMovie.id {
                            filteredItems.remove(at: index)
                            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                            break
                        }
                    } else if let tvShow = item as? Movie, let deletedTVShow = object as? Movie {
                        if tvShow.id == deletedTVShow.id {
                            filteredItems.remove(at: index)
                            collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                            break
                        }
                    }
                }
            }
            delegate?.dataLoaded()
            updateItemOnFocus()
        }
    }

    func getItem(index: Int) -> Any? {
        if index >= 0, index < itemsCount {
            if favouriteFilter == .all {
                return items[index]
            }
            return filteredItems[index]
        }
        return nil
    }

    private func itemAt(_ index: Int) -> Any {
        if favouriteFilter == .all {
            return items[index]
        }
        return filteredItems[index]
    }

    private var itemsCount: Int {
        get {
            if favouriteFilter == .all {
                return items.count
            }
            return filteredItems.count
        }
    }

    private func fetchDataWithCurrentFilter() {
        delegate?.dataIsLoading()
        filteredItems.removeAll()
        itemOnFocus = 0
        switch favouriteFilter {
        case .movies: filteredItems = items.filter { $0 is Movie }
        case .tvShows: filteredItems = items.filter { $0 is TVShow }
        default: break
        }
        if self.dataSourceIsOnFocus {
            collectionView.reloadData()
            callOnFocusDelegate()
        }

        delegate?.dataLoaded()
    }

    private func callOnFocusDelegate() {

        if itemOnFocus >= 0, itemOnFocus < itemsCount {

            if let item = itemAt(itemOnFocus) as? Movie {

                var posterURL: URL? = nil
                if  let posterPath = item.posterPath {
                    posterURL = MovieImagePath.large.path(poster: posterPath)
                }

                delegate?.itemOnFocus(name: item.title, voteAverage: item.voteAverage, genres: GenresData.movieGenreNames(ids: item.genreIDs), year: item.releaseDate, imageURL: posterURL)

            } else if let item = itemAt(itemOnFocus) as? TVShow {

                var posterURL: URL? = nil
                if  let posterPath = item.posterPath {
                    posterURL = MovieImagePath.large.path(poster: posterPath)
                }

                delegate?.itemOnFocus(name: item.title, voteAverage: item.voteAverage, genres: GenresData.movieGenreNames(ids: item.genreIDs), year: item.firstAirDate, imageURL: posterURL)
            }
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

extension FavouriteDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var itemPosterURL: URL?
        if let movie = itemAt(indexPath.item) as? Movie, let posterPath = movie.posterPath {
            itemPosterURL = imageURLForPosterPath(posterPath)
        } else if let tvShow = itemAt(indexPath.item) as? TVShow, let posterPath = tvShow.posterPath {
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
        if let item = itemAt(indexPath.item) as? Movie {
            cell.setData(title: item.title, genreNames: GenresData.movieGenreNames(ids: item.genreIDs), rating: item.voteAverage, posterURL: itemPosterURL)
        } else if let item = itemAt(indexPath.item) as? TVShow {
            cell.setData(title: item.title, genreNames: GenresData.movieGenreNames(ids: item.genreIDs), rating: item.voteAverage, posterURL: itemPosterURL)
        }
        return cell
    }
}

extension FavouriteDataSource: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        var urls = [URL]()
        for indexPath in indexPaths {
            if indexPath.item < itemsCount {
                if let movie = itemAt(indexPath.item) as? Movie, let posterPath = movie.posterPath {
                    urls.append(imageURLForPosterPath(posterPath))
                } else if let tvShow = itemAt(indexPath.item) as? TVShow, let posterPath = tvShow.posterPath {
                    urls.append(imageURLForPosterPath(posterPath))
                }
            }
        }
        preheater.startPreheating(with: urls)
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        var urls = [URL]()
        for indexPath in indexPaths {
            if indexPath.item < itemsCount {
                if let movie = itemAt(indexPath.item) as? Movie, let posterPath = movie.posterPath {
                    urls.append(imageURLForPosterPath(posterPath))
                } else if let tvShow = itemAt(indexPath.item) as? TVShow, let posterPath = tvShow.posterPath {
                    urls.append(imageURLForPosterPath(posterPath))
                }
            }
        }
        preheater.stopPreheating(with: urls)
    }
}

extension FavouriteDataSource: CoverFlowLayoutDelegate {

    func coverFlowFocused(pageIndex: Int) {

        let itemOnFocus = max(0, min(itemsCount - 1, pageIndex))
        if self.itemOnFocus != itemOnFocus {
            self.itemOnFocus = itemOnFocus
            callOnFocusDelegate()
        }
    }
}
