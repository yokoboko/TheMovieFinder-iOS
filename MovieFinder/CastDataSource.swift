//
//  CastDataSource.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 11.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class CastDataSource: NSObject {

    private var items: [Cast]

    init(cast: [Cast]) {
        self.items = cast
        super.init()
    }

    func item(at: Int) -> Cast? {
        guard at >= 0, at < items.count else { return nil }
        return items[at]
    }
}

extension CastDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.reuseIdentifier, for: indexPath) as! CastCell
        var imageURL: URL?
        if let path = item.profilePath {
            imageURL = MovieImagePath.castMedium.path(poster: path)
        }
        cell.setData(actorName: item.name, imageURL: imageURL)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
}
