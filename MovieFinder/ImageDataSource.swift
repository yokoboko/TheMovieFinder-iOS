//
//  ImageDataSource.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 11.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class ImageDataSource: NSObject {

    private var items: [MovieImage]

    init(images: [MovieImage]) {
        self.items = images
        super.init()
    }

    func item(at: Int) -> MovieImage? {
        guard at >= 0, at < items.count else { return nil }
        return items[at]
    }
}

extension ImageDataSource: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = items[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseIdentifier, for: indexPath) as! ImageCell
        if let imagePath = item.filePath {
            cell.loadImage(imageURL: MovieImagePath.backgropMedium.path(poster: imagePath) )
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
}

