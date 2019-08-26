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
    private let posterRatio: CGFloat = 24 / 36
    private var isCoverflowMode = true
    
    let scrollToTopBtnAlpha: CGFloat = 0.5
    
    private var logoImageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}

// MARK: - Setup Views

extension MainView {
    
    private func setupViews() {
        
        self.backgroundColor = .black
        setupBackgroundView()
        setupSectionAndFilterView()
        setupCollectionView()
        setupButtons()
        hideViewsAndShowLogoWhileLoadingOnAppLaunch()
    }
    
    private func setupBackgroundView() {
        
        backgroundView = BackgroundMoviesView(frame: frame)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    private func setupSectionAndFilterView() {
        
        sectionLabel = UILabel(frame: .zero)
        sectionLabel.textColor = UIColor.movieFinder.secondary
        sectionLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.light)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sectionLabel)
        sectionLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        sectionLabel.topAnchor.constraint(equalTo: safeTopAnchor, constant: 20).isActive = true
        
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

// MARK: - Animations

extension MainView {
 
    private func hideViewsAndShowLogoWhileLoadingOnAppLaunch() {
        
        guard logoImageView == nil else { return }
        
        self.isUserInteractionEnabled = false
        
        logoImageView = UIImageView(image: UIImage(named: "launchscreen_logo"))
        if let logoImageView = logoImageView {
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(logoImageView)
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            logoImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -32).isActive = true
        }
        
        backgroundView.alpha = 0
        sectionLabel.alpha = 0
        filterLabel.alpha = 0
        collectionView.alpha = 0
        scrollToTopBtn.alpha = 0
        toggleLayoutBtn.alpha = 0
        filtersBtn.alpha = 0
    }
    
    func showViewsAfterLoadingDataOnAppLaunch() {
        
        guard let logoImageView = logoImageView  else { return }
        
        UIView.animate(withDuration: 0.6, delay: 0, options: [.curveEaseOut], animations: {
            logoImageView.alpha = 0
            logoImageView.transform = CGAffineTransform(translationX: 0, y: -64)
        }) { (success) in
            self.removeLogo()
        }
        
        sectionLabel.transform = CGAffineTransform(translationX: 0, y: 32)
        filterLabel.transform = CGAffineTransform(translationX: 0, y: 32)
        collectionView.transform = CGAffineTransform(translationX: 0, y: 56)
        scrollToTopBtn.transform = CGAffineTransform(translationX: 0, y: 74)
        toggleLayoutBtn.transform = CGAffineTransform(translationX: 0, y: 74)
        filtersBtn.transform = CGAffineTransform(translationX: 0, y: 74)
        
        UIView.animate(withDuration: 0.8, delay: 0.6, options: [.curveEaseOut], animations: {
            self.sectionLabel.alpha = 1
            self.sectionLabel.transform = .identity
            self.filterLabel.alpha = 1
            self.filterLabel.transform = .identity
            self.collectionView.alpha = 1
            self.collectionView.transform = .identity
            self.scrollToTopBtn.alpha = self.scrollToTopBtnAlpha
            self.scrollToTopBtn.transform = .identity
            self.toggleLayoutBtn.alpha = 1
            self.toggleLayoutBtn.transform = .identity
            self.filtersBtn.alpha = 1
            self.filtersBtn.transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 1.2, delay: 1, options: [.curveEaseOut], animations: {
            self.backgroundView.alpha = 1
        }) { (success) in
            self.isUserInteractionEnabled = true
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { self.hideViewsAndShowLogoWhileLoadingOnAppLaunch() }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { self.showViewsAfterLoadingDataOnAppLaunch() }
    }
    
    private func removeLogo() {
        
        guard let logoImageView = logoImageView  else { return }
        willRemoveSubview(logoImageView)
        self.logoImageView = nil
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
