//
//  MovieDataSource.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 22.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit
import Nuke

class MovieDataSource: NSObject {
    
    var delegate: DataSourceDelegate?
    
    private unowned var collectionView: UICollectionView
    
    private var page = 0
    private var totalPages = 0
    private var items = [Movie]()

    private var isFetching = false

    private var itemOnFocus = -1
    
    private var firstLoad = true
    
    private let preheater = ImagePreheater()

    private var movieFilter: MovieFilter = .popular

    private weak var dataTask: URLSessionDataTask?


    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        //loadWith(movieFilter: MovieFilter.upcoming) // loadWith(movieFilter: MovieFilter.search("Kill"))
    }

    func loadWith(movieFilter: MovieFilter) {

        self.movieFilter = movieFilter
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
        var params = ["page": "\(page + 1)"]

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
        dataTask?.cancel()
        dataTask = MovieAPI.shared.GET(endpoint: endpoint,
                                 params: params,
                                 printDebug: true) { [weak self] (result: Result<MovieResponse, MovieAPIError>) in
    
                                    guard let self = self else { return }


                                    switch result {
                                    case .success(let response):
                                        
                                        self.page = response.page
                                        self.totalPages = response.totalPages

                                        // First load
                                        if self.page == 1, !self.items.isEmpty {
                                            self.items.removeAll()
                                            self.collectionView.reloadData()
                                        }

                                        self.collectionView.performBatchUpdates({
                                            self.items.append(contentsOf: response.results)
                                            var insertedItemsIndex = [IndexPath]()
                                            let end = self.items.count
                                            let start = end - response.results.count
                                            for i in start..<end {
                                                insertedItemsIndex.append(IndexPath(item: i, section: 0))
                                            }
                                            self.collectionView.insertItems(at: insertedItemsIndex)
                                        }, completion: nil)

                                        if self.itemOnFocus == -1 && !self.items.isEmpty {
                                            self.itemOnFocus = 0
                                            self.callOnFocusDelegate()
                                        }
                                    case .failure(let error):
                                        print("Error: \(error)")
                                    }

                                    self.isFetching = false
            }
    }

    private func callOnFocusDelegate() {
        
        let item = items[itemOnFocus]
        var posterURL: URL? = nil
        if  let posterPath = item.posterPath {
            posterURL = MovieImagePath.medium.path(poster: posterPath)
        }
        
        delegate?.movieOnFocus(name: item.title, voteAverage: item.voteAverage, genres: GenresData.movieGenreNames(ids: item.genreIds), year: item.releaseDate, imageURL: posterURL)
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
        if let rating = item.voteAverage {
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
        for indexPath in indexPaths {
            if let posterPath = items[indexPath.item].posterPath {
                urls.append(imageURLForPosterPath(posterPath))
            }
        }
        preheater.startPreheating(with: urls)
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        var urls = [URL]()
        for indexPath in indexPaths {
            if let posterPath = items[indexPath.item].posterPath {
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
