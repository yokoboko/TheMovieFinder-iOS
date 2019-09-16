//
//  MovieDetailView.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 6.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class MovieDetailView: UIView {

    private let margin: CGFloat = 30

    var posterView: UIView!
    var posterImageView: UIImageView!
    var posterViewOriginalFrame: CGRect { return CGRect(x: safeInsets.left + margin, y: safeInsets.top + 48, width: 130, height: 195) }
    var posterTopConstraint: NSLayoutConstraint!
    var posterLeftConstraint: NSLayoutConstraint!
    var posterWidthConstraint: NSLayoutConstraint!
    var posterHeightConstraint: NSLayoutConstraint!
    var visualEffectView: UIVisualEffectView!
    let blurEffect = UIBlurEffect(style: .dark)
    var scrollView: UIScrollView!
    var containerView: UIView!
    var dismissBtn: UIButton!
    var posterDismissBtn:  UIButton!

    var posterInfoSV: UIStackView!
    var ratingLabel: UIPaddedLabel!
    var favouriteBtn: FaveButton!
    var genreLabel: UIPaddedLabel!
    var dateLabel: UIPaddedLabel!
    var durationLabel: UIPaddedLabel!
    var homepageBtn: UIButton!

    var infoSV: UIStackView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!

    var trailersSV: UIStackView!
    var trailersLabel: UIPaddedLabel!
    var trailersCV: UICollectionView!

    var imagesSV: UIStackView!
    var imagesLabel: UIPaddedLabel!
    var imagesCV: UICollectionView!

    var castSV: UIStackView!
    var castLabel: UIPaddedLabel!
    var castCV: UICollectionView!

    var similarSV: UIStackView!
    var similarLabel: UIPaddedLabel!
    var similarCV: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    func animateLayout() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
}

extension MovieDetailView {

    private func setupViews() {

        setupBackgroundView()
        setupScrollView()
        setupPosterView()
        setupDismissButton()
        setupPosterInfoView()
        setupInfoView()
        setupTrailersView()
        setupImagesView()
        setupCastView()
        setupSimilarView()
    }

    private func setupBackgroundView() {

        backgroundColor = .clear

        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = frame
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(visualEffectView)

        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            visualEffectView.leftAnchor.constraint(equalTo: leftAnchor),
            visualEffectView.rightAnchor.constraint(equalTo: rightAnchor)
            ])
    }

    private func setupScrollView() {

        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)

        let containerHeightAnchor = containerView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        containerHeightAnchor.priority = .defaultLow
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeTopAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeBottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),

            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            containerHeightAnchor
            ])
    }

    private func setupPosterView() {

        let posterClipContainer = UIView() // clip layer for safe top
        posterClipContainer.translatesAutoresizingMaskIntoConstraints = false
        posterClipContainer.clipsToBounds = true
        posterClipContainer.isUserInteractionEnabled = false
        addSubview(posterClipContainer)

        posterView = UIView()
        posterView.translatesAutoresizingMaskIntoConstraints = false
        posterClipContainer.addSubview(posterView)

        let shadowImage = UIImage(named: "shadow")?.resizableImage(withCapInsets: UIEdgeInsets(top: 20, left: 33, bottom: 39, right: 33), resizingMode: .stretch)
        let imageShadowView = UIImageView(image: shadowImage)
        imageShadowView.contentMode = .scaleToFill
        imageShadowView.translatesAutoresizingMaskIntoConstraints = false
        imageShadowView.isUserInteractionEnabled = false
        imageShadowView.setContentHuggingPriority(.init(1), for: .horizontal)
        imageShadowView.setContentHuggingPriority(.init(1), for: .vertical)
        imageShadowView.setContentCompressionResistancePriority(.init(1), for: .horizontal)
        imageShadowView.setContentCompressionResistancePriority(.init(1), for: .vertical)
        posterView.addSubview(imageShadowView)

        posterImageView = UIImageView(frame: posterViewOriginalFrame)
        posterImageView.backgroundColor = UIColor.black
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.setContentHuggingPriority(.init(1), for: .horizontal)
        posterImageView.setContentHuggingPriority(.init(1), for: .vertical)
        posterImageView.setContentCompressionResistancePriority(.init(1), for: .horizontal)
        posterImageView.setContentCompressionResistancePriority(.init(1), for: .vertical)
        posterImageView.layer.cornerRadius = 5
        posterImageView.clipsToBounds = true
        posterView.addSubview(posterImageView)

        let originalFrame = posterViewOriginalFrame

        posterTopConstraint = posterView.topAnchor.constraint(equalTo: topAnchor, constant: originalFrame.minY)
        posterLeftConstraint =  posterView.leftAnchor.constraint(equalTo: leftAnchor, constant: originalFrame.minX)
        posterWidthConstraint = posterView.widthAnchor.constraint(equalToConstant: originalFrame.width)
        posterHeightConstraint = posterView.heightAnchor.constraint(equalToConstant: originalFrame.height)

        NSLayoutConstraint.activate([

            posterClipContainer.topAnchor.constraint(equalTo: safeTopAnchor),
            posterClipContainer.bottomAnchor.constraint(equalTo: safeBottomAnchor),
            posterClipContainer.leftAnchor.constraint(equalTo: safeLeftAnchor),
            posterClipContainer.rightAnchor.constraint(equalTo: safeRightAnchor),

            posterTopConstraint,
            posterLeftConstraint,
            posterWidthConstraint,
            posterHeightConstraint,

            imageShadowView.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: -14),
            imageShadowView.bottomAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 38),
            imageShadowView.leftAnchor.constraint(equalTo: posterImageView.leftAnchor, constant: -27),
            imageShadowView.rightAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 27),

            posterImageView.topAnchor.constraint(equalTo: posterView.topAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: posterView.bottomAnchor),
            posterImageView.leftAnchor.constraint(equalTo: posterView.leftAnchor),
            posterImageView.rightAnchor.constraint(equalTo: posterView.rightAnchor)
            ])
    }

    private func setupDismissButton() {

        dismissBtn = UIButton()
        dismissBtn.setImage(UIImage(named: "icon_swipe_down"), for: .normal)
        dismissBtn.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dismissBtn)

        posterDismissBtn = UIButton()
        posterDismissBtn.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(posterDismissBtn)

        let posterFrame = posterViewOriginalFrame
        NSLayoutConstraint.activate([
            dismissBtn.widthAnchor.constraint(equalToConstant: 44),
            dismissBtn.heightAnchor.constraint(equalToConstant: 44),
            dismissBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            dismissBtn.topAnchor.constraint(equalTo: containerView.topAnchor),

            posterDismissBtn.widthAnchor.constraint(equalToConstant: posterFrame.width),
            posterDismissBtn.heightAnchor.constraint(equalToConstant: posterFrame.height),
            posterDismissBtn.topAnchor.constraint(equalTo: containerView.topAnchor, constant: posterFrame.minY - safeInsets.top),
            posterDismissBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: posterFrame.minX - safeInsets.left)
            ])
    }

    private func setupPosterInfoView() {

        posterInfoSV = UIStackView()
        posterInfoSV.translatesAutoresizingMaskIntoConstraints = false
        posterInfoSV.distribution = .equalSpacing
        posterInfoSV.axis = .vertical
        posterInfoSV.spacing = 0
        containerView.addSubview(posterInfoSV)

        favouriteBtn = FaveButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44),
                                  faveIconNormal: UIImage(named: "btn_favourite_inactive"),
                                  faveIconSelected: UIImage(named: "btn_favourite_active"))
        favouriteBtn.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(favouriteBtn)

        ratingLabel = UIPaddedLabel()
        ratingLabel.textColor = UIColor.movieFinder.secondary
        ratingLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.black)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        ratingLabel.bottomInset = 4
        posterInfoSV.addArrangedSubview(ratingLabel)

        genreLabel = UIPaddedLabel()
        genreLabel.textColor = UIColor.movieFinder.tertiery
        genreLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.numberOfLines = 4
        genreLabel.topInset = 4
        genreLabel.bottomInset = 4
        posterInfoSV.addArrangedSubview(genreLabel)

        dateLabel = UIPaddedLabel()
        dateLabel.textColor = UIColor.movieFinder.tertiery
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topInset = 4
        dateLabel.bottomInset = 4
        posterInfoSV.addArrangedSubview(dateLabel)

        durationLabel = UIPaddedLabel()
        durationLabel.textColor = UIColor.movieFinder.tertiery
        durationLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.topInset = 4
        durationLabel.bottomInset = 4
        posterInfoSV.addArrangedSubview(durationLabel)

        homepageBtn = UIButton()
        homepageBtn.translatesAutoresizingMaskIntoConstraints = false
        homepageBtn.contentHorizontalAlignment = .left
        homepageBtn.setTitleColor(UIColor.movieFinder.tertiery, for: .normal)
        homepageBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        posterInfoSV.addArrangedSubview(homepageBtn)

        NSLayoutConstraint.activate([
            posterInfoSV.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 48),
            //posterInfoSV.leftAnchor.constraint(equalTo: posterView.rightAnchor, constant: 20),
            posterInfoSV.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: posterViewOriginalFrame.maxX + 20),
            posterInfoSV.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -(margin * 2) - posterViewOriginalFrame.width -  20),

            favouriteBtn.widthAnchor.constraint(equalToConstant: 44),
            favouriteBtn.heightAnchor.constraint(equalToConstant: 44),
            favouriteBtn.rightAnchor.constraint(equalTo: posterInfoSV.rightAnchor, constant: 12),
            favouriteBtn.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor, constant: -4)
            ])
    }

    private func setupInfoView() {

        infoSV = UIStackView()
        infoSV.translatesAutoresizingMaskIntoConstraints = false
        infoSV.distribution = .equalSpacing
        infoSV.axis = .vertical
        infoSV.spacing = 24
        containerView.addSubview(infoSV)

        let infoTextSV = UIStackView()
        infoTextSV.translatesAutoresizingMaskIntoConstraints = false
        infoTextSV.distribution = .equalSpacing
        infoTextSV.axis = .vertical
        infoTextSV.spacing = 16
        infoTextSV.layoutMargins = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        infoTextSV.isLayoutMarginsRelativeArrangement = true
        infoSV.addArrangedSubview(infoTextSV)

        titleLabel = UILabel()
        titleLabel.textColor = UIColor.movieFinder.secondary
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.black)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 3
        infoTextSV.addArrangedSubview(titleLabel)

        descriptionLabel = UILabel()
        descriptionLabel.textColor = UIColor.movieFinder.tertiery
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        descriptionLabel.numberOfLines  = 20
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        infoTextSV.addArrangedSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            infoSV.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            infoSV.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            infoSV.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 48 + 195 + 24),
            infoSV.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -40)
            ])
    }

    private func setupTrailersView() {

        trailersSV = UIStackView()
        trailersSV.translatesAutoresizingMaskIntoConstraints = false
        trailersSV.distribution = .equalSpacing
        trailersSV.axis = .vertical
        trailersSV.spacing = 12
        trailersSV.isHidden = true
        infoSV.addArrangedSubview(trailersSV)

        trailersLabel = UIPaddedLabel()
        trailersLabel.leftInset = margin
        trailersLabel.rightInset = margin
        trailersLabel.textColor = UIColor.movieFinder.secondary
        trailersLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        trailersLabel.text = "trailers".localized
        trailersLabel.translatesAutoresizingMaskIntoConstraints = false
        trailersSV.addArrangedSubview(trailersLabel)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 228, height: 128 + 28)
        flowLayout.minimumLineSpacing = 24
        flowLayout.minimumInteritemSpacing = 24
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        trailersCV = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        trailersCV.translatesAutoresizingMaskIntoConstraints = false
        trailersCV.heightAnchor.constraint(equalToConstant: flowLayout.itemSize.height).isActive = true
        trailersCV.showsHorizontalScrollIndicator = false
        trailersCV.backgroundColor = .clear
        trailersCV.clipsToBounds = false
        trailersCV.register(TrailerCell.self, forCellWithReuseIdentifier: TrailerCell.reuseIdentifier)
        trailersSV.addArrangedSubview(trailersCV)
    }

    private func setupImagesView() {

        imagesSV = UIStackView()
        imagesSV.translatesAutoresizingMaskIntoConstraints = false
        imagesSV.distribution = .equalSpacing
        imagesSV.axis = .vertical
        imagesSV.spacing = 12
        imagesSV.isHidden = true
        infoSV.addArrangedSubview(imagesSV)

        imagesLabel = UIPaddedLabel()
        imagesLabel.leftInset = margin
        imagesLabel.rightInset = margin
        imagesLabel.textColor = UIColor.movieFinder.secondary
        imagesLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        imagesLabel.text = "images".localized
        imagesLabel.translatesAutoresizingMaskIntoConstraints = false
        imagesSV.addArrangedSubview(imagesLabel)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 24
        flowLayout.minimumInteritemSpacing = 24
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        imagesCV = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        imagesCV.translatesAutoresizingMaskIntoConstraints = false
        imagesCV.heightAnchor.constraint(equalToConstant: 128).isActive = true
        imagesCV.showsHorizontalScrollIndicator = false
        imagesCV.backgroundColor = .clear
        imagesCV.clipsToBounds = false
        imagesCV.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseIdentifier)
        imagesSV.addArrangedSubview(imagesCV)
    }

    private func setupCastView() {

        castSV = UIStackView()
        castSV.translatesAutoresizingMaskIntoConstraints = false
        castSV.distribution = .equalSpacing
        castSV.axis = .vertical
        castSV.spacing = 12
        castSV.isHidden = true
        infoSV.addArrangedSubview(castSV)

        castLabel = UIPaddedLabel()
        castLabel.leftInset = margin
        castLabel.rightInset = margin
        castLabel.textColor = UIColor.movieFinder.secondary
        castLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        castLabel.text = "cast".localized
        castLabel.translatesAutoresizingMaskIntoConstraints = false
        castSV.addArrangedSubview(castLabel)

        let castImageRatio: CGFloat = 2 / 3
        let imageHeight: CGFloat = 180
        let imageWidth: CGFloat = imageHeight * castImageRatio
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: imageWidth, height: imageHeight + 38)
        flowLayout.minimumLineSpacing = 24
        flowLayout.minimumInteritemSpacing = 24
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        castCV = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        castCV.translatesAutoresizingMaskIntoConstraints = false
        castCV.heightAnchor.constraint(equalToConstant: flowLayout.itemSize.height).isActive = true
        castCV.showsHorizontalScrollIndicator = false
        castCV.backgroundColor = .clear
        castCV.clipsToBounds = false
        castCV.register(CastCell.self, forCellWithReuseIdentifier: CastCell.reuseIdentifier)
        castSV.addArrangedSubview(castCV)
    }

    private func setupSimilarView() {

        similarSV = UIStackView()
        similarSV.translatesAutoresizingMaskIntoConstraints = false
        similarSV.distribution = .equalSpacing
        similarSV.axis = .vertical
        similarSV.spacing = 12
        similarSV.isHidden = true
        infoSV.addArrangedSubview(similarSV)

        similarLabel = UIPaddedLabel()
        similarLabel.leftInset = margin
        similarLabel.rightInset = margin
        similarLabel.textColor = UIColor.movieFinder.secondary
        similarLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        similarLabel.text = "similar".localized
        similarLabel.translatesAutoresizingMaskIntoConstraints = false
        similarSV.addArrangedSubview(similarLabel)

        let similarImageRatio: CGFloat = 24 / 36
        let imageHeight: CGFloat = 180
        let imageWidth: CGFloat = imageHeight * similarImageRatio
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: imageWidth, height: imageHeight + 38)
        flowLayout.minimumLineSpacing = 24
        flowLayout.minimumInteritemSpacing = 24
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        similarCV = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        similarCV.translatesAutoresizingMaskIntoConstraints = false
        similarCV.heightAnchor.constraint(equalToConstant: flowLayout.itemSize.height).isActive = true
        similarCV.showsHorizontalScrollIndicator = false
        similarCV.backgroundColor = .clear
        similarCV.clipsToBounds = false
        similarCV.register(PosterSmallCell.self, forCellWithReuseIdentifier: PosterSmallCell.reuseIdentifier)
        similarSV.addArrangedSubview(similarCV)
    }
}


// MARK: - Set info

extension MovieDetailView {

    func setBasicInfo(title: String,
                              description: String?,
                              rating: Double?,
                              genresNames: [String],
                              date: String?) {

        titleLabel.text = title

        if let description = description {
            descriptionLabel.text = description
        } else {
            descriptionLabel.isHidden = true
        }

        if let rating = rating, rating != 0.0 {
            let ratingString = String(rating)
            let ratingAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.movieFinder.secondary,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.black)
            ]
            let ratingMaxAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.movieFinder.tertiery,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.light)
            ]
            let ratingAttributedString = NSMutableAttributedString(string: ratingString, attributes: ratingAttributes)
            ratingAttributedString.append(NSAttributedString(string: "/10", attributes: ratingMaxAttributes))
            ratingLabel.attributedText = ratingAttributedString
        } else {
            ratingLabel.isHidden = true
        }

        if genresNames.isEmpty {
            genreLabel.isHidden = true
        } else {
            genreLabel.text = genresNames.joined(separator: ", ")
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = date, let dateObject = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateLabel.text = dateFormatter.string(from: dateObject)
        } else {
            dateLabel.isHidden = true
        }

        durationLabel.isHidden = true
        homepageBtn.isHidden = true
    }
}
