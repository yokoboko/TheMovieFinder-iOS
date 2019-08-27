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
    
    var infoNameLabel: UILabel!
    var infoRatingLabel: UILabel!
    var infoGenresLabel: UILabel!
    
    var scrollToTopBtn: UIButton!
    var toggleLayoutBtn: UIButton!
    var filtersBtn: UIButton!
    
    var collectionView: UICollectionView!
    var coverFlowLayout = CoverFlowLayout()
    private var flowLayout = UICollectionViewFlowLayout()

    private let coverFlowLayoutHorizontalInsets: CGFloat = 40.0
    private let flowLayoutHorizontalInsets: CGFloat = 24.0
    private let posterRatio: CGFloat = 24 / 36
    private let buttonMargin: CGFloat = 40.0
    
    
    private var collectionViewTopConstraint: NSLayoutConstraint!
    private var collectionViewBottomConstraint: NSLayoutConstraint!
    private let collectionViewTopMargin: CGFloat = 92
    private let collectionViewTopMarginFilters: CGFloat = 92
    private let collectionViewBottomMarginFilters: CGFloat = -256
    private let collectionViewBottomMarginCoverFlow: CGFloat = -128
    private let collectionViewBottomMarginFlow: CGFloat = -72
    
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
    
    func setInfo(name: String, rating: Double?, genres: [String], date: String?) {
        
        infoNameLabel.text = name
        
        if let rating = rating {
            let ratingString = String(rating)
            let ratingAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.movieFinder.secondary,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
            ]
            let ratingMaxAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.movieFinder.tertiery,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.ultraLight)
            ]
            let ratingAttributedString = NSMutableAttributedString(string: ratingString, attributes: ratingAttributes)
            ratingAttributedString.append(NSAttributedString(string: "/10", attributes: ratingMaxAttributes))
            infoRatingLabel.attributedText = ratingAttributedString
        } else {
            infoRatingLabel.text = ""
        }
        
        var genresString = ""
        if genres.count > 0 {
            genresString = genres.joined(separator: ", ")
            if date != nil {
                genresString += " | "
            }
        }
        if var date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let dateObject = dateFormatter.date(from: date) {
                dateFormatter.dateFormat = "dd-MM-yyyy"
                date = dateFormatter.string(from: dateObject)
            }
            genresString += date
        }
        infoGenresLabel.text = genresString
    }
}

// MARK: - Setup Views

extension MainView {
    
    private func setupViews() {
        
        self.backgroundColor = .black
        setupBackgroundView()
        setupSectionAndFilterView()
        setupInfoView()
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
        
        collectionViewTopConstraint = collectionView.topAnchor.constraint(equalTo: safeTopAnchor, constant: collectionViewTopMarginFilters)
        collectionViewBottomConstraint = collectionView.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: collectionViewBottomMarginCoverFlow)
        
        NSLayoutConstraint.activate([
            collectionViewTopConstraint,
            collectionViewBottomConstraint,
            collectionView.leftAnchor.constraint(equalTo: safeLeftAnchor),
            collectionView.rightAnchor.constraint(equalTo: safeRightAnchor),
        ])
        
        collectionView.isPrefetchingEnabled = true
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 24
        flowLayout.minimumInteritemSpacing = 32
        
        collectionView.register(PosterBigCell.self, forCellWithReuseIdentifier: PosterBigCell.reuseIdentifier)
    }

    private func setupInfoView() {
        
        infoGenresLabel = UILabel(frame: .zero)
        infoGenresLabel.textColor = UIColor.movieFinder.tertiery
        infoGenresLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        infoGenresLabel.translatesAutoresizingMaskIntoConstraints = false
        infoGenresLabel.adjustsFontSizeToFitWidth = true
        infoGenresLabel.minimumScaleFactor = 0.75
        addSubview(infoGenresLabel)
        
        infoRatingLabel = UILabel(frame: .zero)
        infoRatingLabel.textColor = UIColor.movieFinder.secondary
        infoRatingLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        infoRatingLabel.translatesAutoresizingMaskIntoConstraints = false
        infoRatingLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addSubview(infoRatingLabel)
        
        infoNameLabel = UILabel(frame: .zero)
        infoNameLabel.textColor = UIColor.movieFinder.secondary
        infoNameLabel.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.semibold)
        infoNameLabel.translatesAutoresizingMaskIntoConstraints = false
        infoNameLabel.adjustsFontSizeToFitWidth = true
        infoNameLabel.minimumScaleFactor = 0.7
        addSubview(infoNameLabel)

        NSLayoutConstraint.activate([
            infoGenresLabel.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -64),
            infoGenresLabel.leftAnchor.constraint(equalTo: safeLeftAnchor, constant: buttonMargin),
            infoGenresLabel.rightAnchor.constraint(equalTo: safeRightAnchor, constant: -buttonMargin),
            
            infoRatingLabel.centerYAnchor.constraint(equalTo: infoNameLabel.centerYAnchor, constant: 2),
            infoRatingLabel.rightAnchor.constraint(equalTo: safeRightAnchor, constant: -buttonMargin),
            
            infoNameLabel.bottomAnchor.constraint(equalTo: infoGenresLabel.topAnchor, constant: -2),
            infoNameLabel.leftAnchor.constraint(equalTo: safeLeftAnchor, constant: buttonMargin),
            infoNameLabel.rightAnchor.constraint(equalTo: infoRatingLabel.leftAnchor, constant: -16)
        ])
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
        infoNameLabel.alpha = 0
        infoRatingLabel.alpha = 0
        infoGenresLabel.alpha = 0
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
        infoNameLabel.transform = CGAffineTransform(translationX: 0, y: 66)
        infoRatingLabel.transform = CGAffineTransform(translationX: 0, y: 66)
        infoGenresLabel.transform = CGAffineTransform(translationX: 0, y: 74)
        scrollToTopBtn.transform = CGAffineTransform(translationX: 0, y: 80)
        toggleLayoutBtn.transform = CGAffineTransform(translationX: 0, y: 80)
        filtersBtn.transform = CGAffineTransform(translationX: 0, y: 80)
        
        UIView.animate(withDuration: 0.8, delay: 0.6, options: [.curveEaseOut], animations: {
            self.sectionLabel.alpha = 1
            self.sectionLabel.transform = .identity
            self.filterLabel.alpha = 1
            self.filterLabel.transform = .identity
            self.collectionView.alpha = 1
            self.collectionView.transform = .identity
            self.infoNameLabel.alpha = 1
            self.infoNameLabel.transform = .identity
            self.infoRatingLabel.alpha = 1
            self.infoRatingLabel.transform = .identity
            self.infoGenresLabel.alpha = 1
            self.infoGenresLabel.transform = .identity
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
        
        // For testing fade in animation on app launch
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { self.hideViewsAndShowLogoWhileLoadingOnAppLaunch() }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { self.showViewsAfterLoadingDataOnAppLaunch() }
    }
    
    private func removeLogo() {
        
        guard let logoImageView = logoImageView  else { return }
        willRemoveSubview(logoImageView)
        self.logoImageView = nil
    }
    
    func showInfo() {
        
        guard isCoverflowMode else { return }
        stopInfoAnimation()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.infoNameLabel.alpha = 1
            self.infoRatingLabel.alpha = 1
            self.infoGenresLabel.alpha = 1
            self.infoNameLabel.transform = .identity
            self.infoRatingLabel.transform = .identity
            self.infoGenresLabel.transform = .identity
        })
    }
    
    func hideInfo() {
        
        guard isCoverflowMode else { return }
        stopInfoAnimation()
        
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.infoNameLabel.alpha = 0
            self.infoRatingLabel.alpha = 0
            self.infoGenresLabel.alpha = 0
            self.infoNameLabel.transform = CGAffineTransform(translationX: 0, y: 8)
            self.infoRatingLabel.transform = CGAffineTransform(translationX: 0, y: 8)
            self.infoGenresLabel.transform = CGAffineTransform(translationX: 0, y: 8)
        })
    }
    
    private func stopInfoAnimation() {
        
        infoNameLabel.layer.removeAllAnimations()
        infoRatingLabel.layer.removeAllAnimations()
        infoGenresLabel.layer.removeAllAnimations()
    }
}



// MARK: - CollectionView Cell Size and Actions

extension MainView {
    
    // Call on viewDidLayoutSubviews
    func updateItemSize() {
        coverFlowLayout.itemSize = cellSizeCoverFlowLayout
        flowLayout.itemSize = cellSizeFlowLayout
    }
    
    // Toggle between CoverFlowLayout and FlowLayout
    func collectionViewToggleLayout() {
        
        let visibleItems = collectionView.indexPathsForVisibleItems.sorted { $0.item < $1.item } //.compactMap { collectionView.cellForItem(at: $0) }
        
        hideInfo()
        isCoverflowMode.toggle()
        showInfo()
        
        toggleLayoutBtn.setImage(UIImage(named: isCoverflowMode ? "btn_layout_coverflow" : "btn_layout_flow"), for: .normal)
    
        collectionViewBottomConstraint.constant = isCoverflowMode ? collectionViewBottomMarginCoverFlow : collectionViewBottomMarginFlow
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
        updateItemSize()
        
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
    
    func scrollToTop() {
        if collectionView.contentOffset.x >= collectionView.bounds.width {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
            if isCoverflowMode { coverFlowLayout.updateFocusedToFirstItem() }
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
