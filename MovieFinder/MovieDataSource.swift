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

    private var itemOnFocus = -1
    
    private var firstLoad = true
    
    private let preheater = ImagePreheater()
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        
        fetch()
    }
    
    private func fetch() {
        
            MovieAPI.shared.GET(endpoint: .moviePopular,
                                 params: ["page": "\(page + 1)"],
                                 printDebug: true) { [weak self] (result: Result<MovieResponse, MovieAPIError>) in
    
                                    guard let self = self else { return }
                                    
                                    switch result {
                                    case .success(let response):
                                        
                                        self.page = response.page
                                        self.totalPages = response.totalPages
                                        self.items = response.results
                                        self.collectionView.reloadData()
                                        
                                        if self.itemOnFocus == -1 && self.items.count > 0 {
                                            self.itemOnFocus = 0
                                            self.callOnFocusDelegate()
                                        }
                                    case .failure(let error):
                                        print("Error: \(error)")
                                    }
            }
    }

    private func callOnFocusDelegate() {
        
        let item = items[itemOnFocus]
        var posterURL: URL? = nil
        if  let posterPath = item.posterPath {
            posterURL = MovieImagePath.medium.path(poster: posterPath)
        }
        
        delegate?.movieOnFocus(title: item.title, voteAverage: item.voteAverage, genres: GenresData.movieGenreNames(ids: item.genreIds), imageURL: posterURL)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterBigCell.reuseIdentifier, for: indexPath) as! PosterBigCell
        if let posterPath = items[indexPath.item].posterPath {
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
