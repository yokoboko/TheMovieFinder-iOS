//
//  MainVC.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    let mainView = MainView()

    // Data Sources for collection view(Movies, TV Shows and Favourites)
    private var movieDataSource: MovieDataSource!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.delegate = self
        
        movieDataSource = MovieDataSource(collectionView: mainView.collectionView)
        movieDataSource.delegate = self
        
        mainView.collectionView.dataSource = movieDataSource
        mainView.collectionView.prefetchDataSource = movieDataSource
        mainView.coverFlowLayout.delegate = movieDataSource
        
        
        mainView.sectionLabel.text = "movies".localized
        mainView.filterLabel.text = "top_rated".localized
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.updateItemSize()
    }
}



extension MainVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return mainView.collectionViewInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // TODO - hide info
    }
}

extension MainVC: DataSourceDelegate {
    
    func movieOnFocus(title: String, voteAverage: Double?, genreIds: [Int]?, imageURL: URL?) {
        if let imageURL = imageURL {
            mainView.backgroundView.loadImage(url: imageURL)
        }
        // TODO - show info
    }
}
