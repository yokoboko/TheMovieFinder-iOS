//
//  SimilarMovieDataSource.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 11.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class SimilarMovieDataSource: NSObject {

    private var items: [Movie]

    init(movies: [Movie]) {
        self.items = movies
        super.init()
    }

    func item(at: Int) -> Movie? {
        guard at >= 0, at < items.count else { return nil }
        return items[at]
    }
}

extension SimilarMovieDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = items[indexPath.item]
        var itemPosterURL: URL?
        if let posterPath = item.posterPath {
            itemPosterURL = MovieImagePath.small.path(poster: posterPath)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterSmallCell.reuseIdentifier, for: indexPath) as! PosterSmallCell
        cell.setData(title: item.title, genreNames: GenresData.movieGenreNames(ids: item.genreIds), rating: item.voteAverage, posterURL: itemPosterURL)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
}
