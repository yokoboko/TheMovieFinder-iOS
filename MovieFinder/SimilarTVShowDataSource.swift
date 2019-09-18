//
//  SimilarTVShowDataSource.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 18.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class SimilarTVShowDataSource: NSObject {

    private var items: [TVShow]

    init(tvShows: [TVShow]) {
        self.items = tvShows
        super.init()
    }

    func item(at: Int) -> TVShow? {
        guard at >= 0, at < items.count else { return nil }
        return items[at]
    }
}

extension SimilarTVShowDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = items[indexPath.item]
        var itemPosterURL: URL?
        if let posterPath = item.posterPath {
            itemPosterURL = MovieImagePath.medium.path(poster: posterPath)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterSmallCell.reuseIdentifier, for: indexPath) as! PosterSmallCell
        cell.setData(title: item.originalName, genreNames: GenresData.movieGenreNames(ids: item.genreIds), rating: item.voteAverage, posterURL: itemPosterURL)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
}
