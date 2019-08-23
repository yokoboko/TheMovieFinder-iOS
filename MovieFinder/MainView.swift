//
//  MainView.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class MainView: UIView {

    var backgroundView: BackgroundMoviesView!
    var sectionLabel: UILabel!
    var filterLabel: UILabel!
    var scrollToTopBtn: UIButton!
    var toggleLayoutBtn: UIButton!
    var filtersBtn: UIButton!
    private let buttonMargin: CGFloat = 40.0
    
    var collectionView: UICollectionView!
    var coverFlowLayout = CoverFlowLayout()
    private var flowLayout = UICollectionViewFlowLayout()
    private let coverFlowLayoutHorizontalInsets: CGFloat = 40.0
    private let flowLayoutHorizontalInsets: CGFloat = 24.0
    
    private let posterRatio: CGFloat = 24 / 36 //24.3 / 36
    private var isCoverflowMode = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        
        setupBackgroundView()
        setupSectionAndFilterView()
        setupCollectionView()
        setupButtons()
    }
}

    // MARK: - Setup Views
extension MainView {
    
    private func setupBackgroundView() {
        
        backgroundView = BackgroundMoviesView(frame: frame)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        //if let image = UIImage(named: "Background") { backgroundView.setImage(image: image) } // Load default background
    }
    
    private func setupSectionAndFilterView() {
        
        sectionLabel = UILabel(frame: .zero)
        sectionLabel.textColor = UIColor.movieFinder.secondary
        sectionLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.light)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sectionLabel)
        sectionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        sectionLabel.topAnchor.constraint(equalTo: safeTopAnchor, constant: 16).isActive = true
        
        filterLabel = UILabel(frame: .zero)
        filterLabel.textColor = UIColor.movieFinder.tertiery
        filterLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(filterLabel)
        filterLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        filterLabel.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: -2).isActive = true
    }
    
    private func setupCollectionView() {
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: coverFlowLayout)
        collectionView.delaysContentTouches = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.clipsToBounds = false
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeTopAnchor, constant: 92),
            collectionView.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -128),
            collectionView.leftAnchor.constraint(equalTo: safeLeftAnchor),
            collectionView.rightAnchor.constraint(equalTo: safeRightAnchor),
        ])
        
        collectionView.isPrefetchingEnabled = true
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 24
        flowLayout.minimumInteritemSpacing = 32
        

        collectionView.register(PosterBigCell.self, forCellWithReuseIdentifier: PosterBigCell.reuseIdentifier)
    }
    
    private func setupButtons() {
        
        scrollToTopBtn = UIButton(type: .custom)
        scrollToTopBtn.translatesAutoresizingMaskIntoConstraints = false
        scrollToTopBtn.setImage(UIImage(named: "btn_scroll_to_top"), for: .normal)
        addSubview(scrollToTopBtn)
        scrollToTopBtn.leftAnchor.constraint(equalTo: safeLeftAnchor, constant: buttonMargin - 13).isActive = true
        scrollToTopBtn.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -6).isActive = true
        
        toggleLayoutBtn = UIButton(type: .custom)
        toggleLayoutBtn.translatesAutoresizingMaskIntoConstraints = false
        toggleLayoutBtn.setImage(UIImage(named: "btn_layout_coverflow"), for: .normal)
        addSubview(toggleLayoutBtn)
        toggleLayoutBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        toggleLayoutBtn.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -6).isActive = true
        
        filtersBtn = UIButton(type: .custom)
        filtersBtn.translatesAutoresizingMaskIntoConstraints = false
        filtersBtn.setImage(UIImage(named: "btn_filters"), for: .normal)
        addSubview(filtersBtn)
        filtersBtn.rightAnchor.constraint(equalTo: safeRightAnchor, constant: -buttonMargin + 16).isActive = true
        filtersBtn.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -6).isActive = true
    }
    
}

// MARK: - Cell sizes and Toggle Layout

extension MainView {
    
    // Call on viewDidLayoutSubviews
    func updateItemSize() {
        coverFlowLayout.itemSize = cellSizeCoverFlowLayout
        flowLayout.itemSize = cellSizeFlowLayout
    }
    
    // Toggle between CoverFlowLayout and FlowLayout
    func collectionViewToggleLayout() {
        
        let visibleItems = collectionView.indexPathsForVisibleItems.sorted { $0.item < $1.item } //.compactMap { collectionView.cellForItem(at: $0) }
        
        isCoverflowMode.toggle()
        
        toggleLayoutBtn.setImage(UIImage(named: isCoverflowMode ? "btn_layout_coverflow" : "btn_layout_flow"), for: .normal)
        
        collectionView.setCollectionViewLayout(isCoverflowMode ? coverFlowLayout : flowLayout, animated: false)
        collectionView.decelerationRate = isCoverflowMode ? .fast : .normal
        
        if visibleItems.count > 0 {
            let indexPathToScroll = !isCoverflowMode && visibleItems.count > 2 ? visibleItems[1] : visibleItems[0]
            collectionView.scrollToItem(at: indexPathToScroll, at: isCoverflowMode ? .centeredHorizontally : .left, animated: false)
            collectionView.collectionViewLayout.invalidateLayout()
            if !isCoverflowMode, collectionView.contentOffset.x > collectionView.contentOffset.x - flowLayoutHorizontalInsets - 0.5 {
                collectionView.contentOffset.x -= flowLayoutHorizontalInsets  - 0.5
            }
        }
        
        if isCoverflowMode {
            collectionView.reloadData()
            coverFlowLayout.updateFocused()
        }
    }
    
    var collectionViewInsets: UIEdgeInsets {
        if isCoverflowMode {
            let leftRightInset = (collectionView.frame.width - cellSizeCoverFlowLayout.width)/2
            return UIEdgeInsets(top: 0, left: leftRightInset, bottom: 0, right: leftRightInset)
        } else {
            return UIEdgeInsets(top: 0, left: flowLayoutHorizontalInsets, bottom: 0, right: flowLayoutHorizontalInsets)
        }
    }
        
    // For single row coverFlowLayout - fit to height and left/right margin of 40
    private var cellSizeCoverFlowLayout: CGSize {
        var width: CGFloat = frame.width - coverFlowLayoutHorizontalInsets * 2
        var height = width / posterRatio
        if height > collectionView.frame.height {
            height = collectionView.frame.height
            width = height * posterRatio
        }
        return CGSize(width: width, height: height)
    }
    
    // For 2 rows flowLayout
    private var cellSizeFlowLayout: CGSize {
        let height = (collectionView.frame.height - flowLayout.minimumInteritemSpacing) / 2
        let width = height * posterRatio
        return CGSize(width: width , height: height)
    }
}
