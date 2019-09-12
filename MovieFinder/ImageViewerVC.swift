//
//  ImageViewerVC.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 12.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit
import Nuke

class ImageViewerVC: UIViewController, UIScrollViewDelegate {

    var imageURL: URL!
    var imageIndex: Int!

    private let imageViewerView = ImageViewerView()
    override func loadView() { view = imageViewerView }

    init(imageURL: URL, imageIndex: Int) {
        self.imageURL = imageURL
        self.imageIndex = imageIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        imageViewerView.scrollView.delegate = self

        Nuke.loadImage(with: imageURL,
                       options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                       into: imageViewerView.imageView)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewerView.imageView
    }
}
