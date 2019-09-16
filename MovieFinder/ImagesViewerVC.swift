//
//  ImagesViewerVC.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 12.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class ImagesViewerVC: UIPageViewController {

    var photos: [URL]
    var firstIndex: Int

    init(photosURLs: [URL], firstIndex: Int = 0) {
        self.photos = photosURLs
        self.firstIndex = firstIndex
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()

        if !photos.isEmpty {
            let index = firstIndex >= 0 && firstIndex < photos.count ? firstIndex : 0
            let viewControllers = [createSingleImageViewerVC(index)]
            setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        }

        dataSource = self

        view.backgroundColor = .black

        let closeBtn = UIButton(frame: .zero)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        //UIButton(frame: CGRect(x: view.frame.width - 50, y: 0, width: 50, height: 50))
        closeBtn.setImage(UIImage(named: "btn_close_dark_transparent"), for: .normal)
        closeBtn.addTarget(self, action: #selector(onCloseAction(_:)), for: .touchUpInside)
        view.addSubview(closeBtn)

        NSLayoutConstraint.activate([
            closeBtn.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 12),
            closeBtn.rightAnchor.constraint(equalTo: view.safeRightAnchor, constant: -12)
            ])
    }

    func createSingleImageViewerVC(_ index: Int) -> ImageViewerVC {

        let photoURL = photos[index]
        let photoIndex = index
        let vc = ImageViewerVC(imageURL: photoURL, imageIndex: photoIndex)
        return vc
    }

    @objc func onCloseAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

extension ImagesViewerVC: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        if let viewController = viewController as? ImageViewerVC,
            viewController.imageIndex > 0 {
            return createSingleImageViewerVC(viewController.imageIndex  - 1)
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        if let viewController = viewController as? ImageViewerVC,
            (viewController.imageIndex + 1) < photos.count {
            return createSingleImageViewerVC(viewController.imageIndex  + 1)
        }
        return nil
    }
}
