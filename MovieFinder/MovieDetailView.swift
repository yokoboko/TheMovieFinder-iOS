//
//  MovieDetailView.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 6.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class MovieDetailView: UIView {

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

    private let margin: CGFloat = 30

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}

extension MovieDetailView {

    private func setupViews() {

        setupBackgroundView()
        setupScrollView()
        setupPosterView()
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

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeTopAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeBottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: safeLeftAnchor),
            scrollView.rightAnchor.constraint(equalTo: safeRightAnchor)
            ])
    }

    private func setupPosterView() {

        posterView = UIView()
        posterView.layer.cornerRadius = 5
        posterView.layer.shadowOffset = CGSize(width: 0, height: 15)
        posterView.layer.shadowRadius = 15
        posterView.layer.shadowOpacity = 0.64
        posterView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(posterView)

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


}
