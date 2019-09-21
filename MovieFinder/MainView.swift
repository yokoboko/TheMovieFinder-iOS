//
//  MainView.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class MainView: UIView {

    var aboutAction: (() -> Void)?

    var backgroundView: BackgroundMoviesView!
    var aboutLabel: UILabel!
    var sectionLabel: UILabel!
    var filterLabel: UILabel!

    var collectionView: UICollectionView!
    var coverFlowLayout = CoverFlowLayout()
    var flowLayout = UICollectionViewFlowLayout()

    var infoNameLabel: UILabel!
    var infoRatingLabel: UILabel!
    var infoGenresLabel: UILabel!

    var scrollToTopContainer: UIView!
    var scrollToTopBtn: UIButton!
    var toggleLayoutBtn: UIButton!
    var filtersBtn: UIButton!

    var filterView: MainFilterView!
    var filterViewTopConstraint: NSLayoutConstraint!
    var isFilterHidden = true
    var filterStartDrag = false
    var filterDragShift: CGFloat = 0.0
    var filterDragDirectionUp = false

    var searchView: MainSearchView!
    var noResultFoundView: MainNoResultFoundView!

    private let collectionViewHorizontalInsets: CGFloat = 40.0
    private let posterRatio: CGFloat = 24 / 36
    private let infoBottomMargin: CGFloat = 40.0
    
    var collectionViewHeightConstraint: NSLayoutConstraint!
    var collectionViewBottomConstraint: NSLayoutConstraint!
    let collectionViewHeightCoverFlowMargin: CGFloat = 220
    let collectionViewHeightFlowMargin: CGFloat = 160
    let collectionViewHeightFlowFiltersMargin: CGFloat = 220
    let collectionViewBottomMarginFilters: CGFloat = -24
    let collectionViewBottomMarginCoverFlow: CGFloat = -128
    let collectionViewBottomMarginFlow: CGFloat = -64

    let filterViewMargin: CGFloat = 6
    
    private var coverFlowLayoutMode = true
    var isCoverFlowLayout: Bool {
        get {
            return coverFlowLayoutMode
        }
    }

    let scrollToTopBtnAlpha: CGFloat = 0.5
    
    var logoImageView: UIImageView?
    
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
        
        if let rating = rating, rating != 0.0 {
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
        if !genres.isEmpty {
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

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleFilterShowHidePanGesture))
        addGestureRecognizer(panGestureRecognizer)

        self.backgroundColor = .black
        setupBackgroundView()
        setupBottomFilterView()
        setupSectionAndFilterView()
        setupInfoView()
        setupCollectionView()
        setupButtons()
        setupNoResultFoundView()
        setupSearchView()
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

        let infoAttachment = NSTextAttachment()
        infoAttachment.image = UIImage(named: "icon_info")
        infoAttachment.bounds = CGRect(x: 0, y: 2, width: infoAttachment.image!.size.width, height: infoAttachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: infoAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        completeText.append(NSAttributedString(string: " \("about".localized)"))

        aboutLabel = UILabel()
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.textColor = UIColor.movieFinder.secondary
        aboutLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFont.Weight.light)
        aboutLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutLabel.attributedText = completeText
        aboutLabel.alpha = 0
        addSubview(aboutLabel)

        sectionLabel = UILabel()
        sectionLabel.textColor = UIColor.movieFinder.secondary
        sectionLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.light)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(sectionLabel)
        
        filterLabel = UILabel()
        filterLabel.textColor = UIColor.movieFinder.tertiery
        filterLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.light)
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        filterLabel.textAlignment = .center
        addSubview(filterLabel)

        NSLayoutConstraint.activate([
            sectionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            sectionLabel.topAnchor.constraint(equalTo: safeTopAnchor, constant: 20),
            filterLabel.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: -2),
            filterLabel.leftAnchor.constraint(equalTo: safeLeftAnchor, constant: 40),
            filterLabel.rightAnchor.constraint(equalTo: safeRightAnchor, constant: -40),
            aboutLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            aboutLabel.bottomAnchor.constraint(equalTo: sectionLabel.topAnchor, constant: -8),
            ])

    }
    
    private func setupCollectionView() {
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: coverFlowLayout)
        collectionView.delaysContentTouches = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.clipsToBounds = false
        addSubview(collectionView)
        collectionView.isPrefetchingEnabled = true
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 24
        flowLayout.minimumInteritemSpacing = 20
        
        collectionView.register(PosterBigCell.self, forCellWithReuseIdentifier: PosterBigCell.reuseIdentifier)
        collectionView.register(PosterSmallCell.self, forCellWithReuseIdentifier: PosterSmallCell.reuseIdentifier)
    }

    func constraintCollectionView() {

        guard collectionViewHeightConstraint == nil else { return }

        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: safeAreaFrame.height - collectionViewHeightCoverFlowMargin)
        collectionViewBottomConstraint = collectionView.bottomAnchor.constraint(equalTo: filterView.topAnchor, constant: collectionViewBottomMarginCoverFlow)

        NSLayoutConstraint.activate([
            collectionViewHeightConstraint,
            collectionViewBottomConstraint,
            collectionView.leftAnchor.constraint(equalTo: safeLeftAnchor),
            collectionView.rightAnchor.constraint(equalTo: safeRightAnchor),
            ])
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
        infoRatingLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        addSubview(infoRatingLabel)
        
        infoNameLabel = UILabel(frame: .zero)
        infoNameLabel.textColor = UIColor.movieFinder.secondary
        infoNameLabel.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.semibold)
        infoNameLabel.translatesAutoresizingMaskIntoConstraints = false
        infoNameLabel.adjustsFontSizeToFitWidth = true
        infoNameLabel.minimumScaleFactor = 0.7
        infoNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        infoNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        addSubview(infoNameLabel)

        NSLayoutConstraint.activate([
            infoGenresLabel.bottomAnchor.constraint(equalTo: filterView.topAnchor, constant: -64),
            infoGenresLabel.leftAnchor.constraint(equalTo: safeLeftAnchor, constant: infoBottomMargin),
            infoGenresLabel.rightAnchor.constraint(equalTo: safeRightAnchor, constant: -infoBottomMargin),
            
            infoRatingLabel.centerYAnchor.constraint(equalTo: infoNameLabel.centerYAnchor, constant: 2),
            infoRatingLabel.rightAnchor.constraint(equalTo: safeRightAnchor, constant: -infoBottomMargin),
            
            infoNameLabel.bottomAnchor.constraint(equalTo: infoGenresLabel.topAnchor, constant: -2),
            infoNameLabel.leftAnchor.constraint(equalTo: safeLeftAnchor, constant: infoBottomMargin),
            infoNameLabel.rightAnchor.constraint(equalTo: infoRatingLabel.leftAnchor, constant: -16)
        ])
    }
    
    private func setupButtons() {

        scrollToTopContainer = UIView()
        scrollToTopContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollToTopContainer)

        scrollToTopBtn = UIButton()
        scrollToTopBtn.translatesAutoresizingMaskIntoConstraints = false
        scrollToTopBtn.setImage(UIImage(named: "btn_scroll_to_top"), for: .normal)
        scrollToTopBtn.alpha = scrollToTopBtnAlpha
        scrollToTopContainer.addSubview(scrollToTopBtn)
        
        toggleLayoutBtn = UIButton(type: .custom)
        toggleLayoutBtn.translatesAutoresizingMaskIntoConstraints = false
        toggleLayoutBtn.setImage(UIImage(named: "btn_layout_coverflow"), for: .normal)
        addSubview(toggleLayoutBtn)

        filtersBtn = UIButton(type: .custom)
        filtersBtn.translatesAutoresizingMaskIntoConstraints = false
        filtersBtn.setImage(UIImage(named: "btn_filters"), for: .normal)
        addSubview(filtersBtn)

        NSLayoutConstraint.activate([
            scrollToTopContainer.leftAnchor.constraint(equalTo: safeLeftAnchor, constant: infoBottomMargin - 13),
            scrollToTopContainer.bottomAnchor.constraint(equalTo: filterView.topAnchor, constant: -6),
            scrollToTopContainer.widthAnchor.constraint(equalTo: scrollToTopBtn.widthAnchor),
            scrollToTopContainer.heightAnchor.constraint(equalTo: scrollToTopBtn.heightAnchor),
            scrollToTopBtn.leftAnchor.constraint(equalTo: scrollToTopContainer.leftAnchor),
            scrollToTopBtn.topAnchor.constraint(equalTo: scrollToTopContainer.topAnchor),
            filtersBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            filtersBtn.bottomAnchor.constraint(equalTo: filterView.topAnchor, constant: -6),
            toggleLayoutBtn.rightAnchor.constraint(equalTo: safeRightAnchor, constant: -infoBottomMargin + 16),
            toggleLayoutBtn.bottomAnchor.constraint(equalTo: filterView.topAnchor, constant: -6),
            ])
    }
    
    private func setupBottomFilterView() {

        filterView = MainFilterView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        filterView.translatesAutoresizingMaskIntoConstraints = false
        filterView.alpha = 0
        filterView.isUserInteractionEnabled = false
        addSubview(filterView)

        filterViewTopConstraint = filterView.topAnchor.constraint(equalTo: safeBottomAnchor, constant: 0)
        NSLayoutConstraint.activate([
                filterViewTopConstraint,
                filterView.rightAnchor.constraint(equalTo: safeRightAnchor, constant: -collectionViewHorizontalInsets),
                filterView.leftAnchor.constraint(equalTo: safeLeftAnchor, constant: collectionViewHorizontalInsets)
            ])
    }

    private func setupNoResultFoundView() {

        noResultFoundView = MainNoResultFoundView()
        noResultFoundView.translatesAutoresizingMaskIntoConstraints = false
        noResultFoundView.isUserInteractionEnabled = false
        noResultFoundView.isHidden = true
        addSubview(noResultFoundView)

        NSLayoutConstraint.activate([
            noResultFoundView.topAnchor.constraint(equalTo: collectionView.topAnchor),
            noResultFoundView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor),
            noResultFoundView.leftAnchor.constraint(equalTo: safeLeftAnchor, constant: collectionViewHorizontalInsets),
            noResultFoundView.rightAnchor.constraint(equalTo: safeRightAnchor, constant: -collectionViewHorizontalInsets)
            ])
    }

    private func setupSearchView() {

        searchView = MainSearchView()
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.isHidden = true
        searchView.alpha = 0
        addSubview(searchView)

        NSLayoutConstraint.activate([
            searchView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16),
            searchView.leftAnchor.constraint(equalTo: leftAnchor),
            searchView.rightAnchor.constraint(equalTo: rightAnchor),
            searchView.heightAnchor.constraint(equalToConstant: 58)
            ])
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
        coverFlowLayoutMode.toggle()
        showInfo()
        
        toggleLayoutBtn.setImage(UIImage(named: coverFlowLayoutMode ? "btn_layout_coverflow" : "btn_layout_flow"), for: .normal)

        let heighMargin = coverFlowLayoutMode ? collectionViewHeightCoverFlowMargin : collectionViewHeightFlowMargin
        collectionViewHeightConstraint.constant = safeAreaFrame.height - heighMargin
        collectionViewBottomConstraint.constant = coverFlowLayoutMode ? collectionViewBottomMarginCoverFlow : collectionViewBottomMarginFlow
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
        updateItemSize()
        
        collectionView.setCollectionViewLayout(coverFlowLayoutMode ? coverFlowLayout : flowLayout, animated: false)
        collectionView.decelerationRate = coverFlowLayoutMode ? .fast : .normal
        
        if !visibleItems.isEmpty {
            var indexPathToScroll = visibleItems[0]
            if indexPathToScroll.item != 0 {
                if coverFlowLayoutMode, visibleItems.count > 2 {
                    indexPathToScroll = visibleItems[2]
                } else if !coverFlowLayoutMode, visibleItems.count > 1{
                    indexPathToScroll = visibleItems[1]
                }
            }
            collectionView.scrollToItem(at: indexPathToScroll, at: coverFlowLayoutMode ? .centeredHorizontally : .left, animated: false)
            collectionView.collectionViewLayout.invalidateLayout()
            if !coverFlowLayoutMode { collectionView.contentOffset.x -= collectionViewHorizontalInsets }
        }
        collectionView.reloadData()
        if coverFlowLayoutMode { coverFlowLayout.updateFocused() }
    }
    
    var collectionViewInsets: UIEdgeInsets {
        if coverFlowLayoutMode {
            let leftRightInset = (collectionView.frame.width - cellSizeCoverFlowLayout.width)/2
            return UIEdgeInsets(top: 0, left: leftRightInset, bottom: 0, right: leftRightInset)
        } else {
            return UIEdgeInsets(top: 0, left: collectionViewHorizontalInsets, bottom: 0, right: collectionViewHorizontalInsets)
        }
    }
    
    func scrollToTop() {
        if collectionView.contentOffset.x > 0 {
            collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
            if coverFlowLayoutMode { coverFlowLayout.updateFocusedToFirstItem() }
        }
    }
    
    
    // For single row coverFlowLayout - fit to height and left/right margin of 40
    var cellSizeCoverFlowLayout: CGSize {
        var width: CGFloat = frame.width - collectionViewHorizontalInsets * 2
        var height = width / posterRatio
        if height > collectionView.frame.height {
            height = collectionView.frame.height
            width = height * posterRatio
        }
        return CGSize(width: width, height: height)
    }
    
    // For 2 rows flowLayout
    var cellSizeFlowLayout: CGSize {
        let footerHeight: CGFloat = 38
        let height = (collectionView.frame.height - flowLayout.minimumInteritemSpacing) / 2
        let posterHeight = height - footerHeight
        let width = posterHeight * posterRatio
        return CGSize(width: width , height: height)
    }
}
