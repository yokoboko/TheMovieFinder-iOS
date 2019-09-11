//
//  TrailerCell.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 10.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit
import Nuke

class TrailerCell: UICollectionViewCell {

    var imageContainerView: UIView!
    var imageView: UIImageView!
    var titleLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {

        //contentView.backgroundColor = UIColor.black.withAlphaComponent(0.0)

        imageContainerView = UIView()
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.backgroundColor = .black
        imageContainerView.layer.cornerRadius = 5
        imageContainerView.layer.shadowOffset = CGSize(width: 0, height: 15)
        imageContainerView.layer.shadowRadius = 15
        imageContainerView.layer.shadowOpacity = 0.64
        contentView.addSubview(imageContainerView)

        imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.init(1), for: .horizontal)
        imageView.setContentHuggingPriority(.init(1), for: .vertical)
        imageView.setContentCompressionResistancePriority(.init(1), for: .horizontal)
        imageView.setContentCompressionResistancePriority(.init(1), for: .vertical)
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageContainerView.addSubview(imageView)

        titleLabel = UILabel()
        titleLabel.textColor = UIColor.movieFinder.tertiery
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)

        let playImage = UIImageView(image: UIImage(named: "icon_play_video"))
        playImage.translatesAutoresizingMaskIntoConstraints = false
        playImage.alpha = 1
        contentView.addSubview(playImage)

        NSLayoutConstraint.activate([

            imageContainerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageContainerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageContainerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28),

            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: imageContainerView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: imageContainerView.rightAnchor),

            playImage.rightAnchor.constraint(equalTo: imageContainerView.rightAnchor, constant: -2),
            playImage.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -2),

            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
            ])
    }

    override func prepareForReuse() {
        isHidden = false
        imageView.image = nil
    }

    private func loadImage(imageURL: URL) {
        Nuke.loadImage(with: imageURL,
                       options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                       into: imageView)
    }

    func setData(title: String?, imageURL: URL?) {

        titleLabel.text = title
        if let imageURL = imageURL {
            loadImage(imageURL: imageURL)
        }
    }
}


