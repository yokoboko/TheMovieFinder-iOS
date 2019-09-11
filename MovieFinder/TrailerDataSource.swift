//
//  TrailerDataSource.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 10.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class TrailerDataSource: NSObject {

    private var items: [MovieVideo]

    init(trailers: [MovieVideo]) {
        self.items = trailers
        super.init()
    }

    func item(at: Int) -> MovieVideo? {
        guard at >= 0, at < items.count else { return nil }
        return items[at]
    }
}

extension TrailerDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrailerCell.reuseIdentifier, for: indexPath) as! TrailerCell
        cell.setData(title: item.name, imageURL: item.thumbURL)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
}
