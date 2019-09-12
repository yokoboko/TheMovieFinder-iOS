//
//  ImageViewerView.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 12.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class ImageViewerView: UIView {

    var scrollView: UIScrollView!
    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}

extension ImageViewerView {

    private func setupViews() {

        backgroundColor = .black

        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        addSubview(scrollView)

        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeTopAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeBottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: safeLeftAnchor),
            scrollView.rightAnchor.constraint(equalTo: safeRightAnchor),

            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            ])
    }
}
