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
    var favouriteBtn: UIButton!
    var genreLabel: UIPaddedLabel!
    var dateLabel: UIPaddedLabel!
    var durationLabel: UIPaddedLabel!
    var homepageBtn: UIButton!

    var infoSV: UIStackView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!

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
    }

    private func setupBackgroundView() {

        backgroundColor = .clear

        visualEffectView = UIVisualEffectView(effect: nil)
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
        posterView.layer.cornerRadius = 5
        posterView.layer.shadowOffset = CGSize(width: 0, height: 15)
        posterView.layer.shadowRadius = 15
        posterView.layer.shadowOpacity = 0.64
        posterView.translatesAutoresizingMaskIntoConstraints = false
        posterClipContainer.addSubview(posterView)

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

        favouriteBtn = UIButton()
        favouriteBtn.translatesAutoresizingMaskIntoConstraints = false
        favouriteBtn.setImage(UIImage(named: "btn_favourite_inactive"), for: .normal)
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
        homepageBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.bold)
        posterInfoSV.addArrangedSubview(homepageBtn)

        NSLayoutConstraint.activate([
            posterInfoSV.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 48),
            //posterInfoSV.leftAnchor.constraint(equalTo: posterView.rightAnchor, constant: 20),
            posterInfoSV.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: posterViewOriginalFrame.maxX + 20),
            posterInfoSV.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -(margin * 2) - posterViewOriginalFrame.width -  20),

            favouriteBtn.widthAnchor.constraint(equalToConstant: 44),
            favouriteBtn.heightAnchor.constraint(equalToConstant: 44),
            favouriteBtn.rightAnchor.constraint(equalTo: posterInfoSV.rightAnchor, constant: 12),
            favouriteBtn.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor)
            ])
    }

    private func setupInfoView() {

        infoSV = UIStackView()
        infoSV.translatesAutoresizingMaskIntoConstraints = false
        infoSV.distribution = .equalSpacing
        infoSV.axis = .vertical
        infoSV.spacing = 16
        containerView.addSubview(infoSV)

        titleLabel = UILabel()
        titleLabel.textColor = UIColor.movieFinder.secondary
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.black)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 3
        infoSV.addArrangedSubview(titleLabel)

        descriptionLabel = UILabel()
        descriptionLabel.textColor = UIColor.movieFinder.tertiery
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        descriptionLabel.numberOfLines  = 20
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        infoSV.addArrangedSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            infoSV.leftAnchor.constraint(equalTo: containerView.safeLeftAnchor, constant: margin),
            infoSV.rightAnchor.constraint(equalTo: containerView.safeRightAnchor, constant: -margin),
            infoSV.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 48 + 195 + 24),
            infoSV.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -32)
            ])
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
