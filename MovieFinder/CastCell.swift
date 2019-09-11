//
//  CastCell.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 11.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit
import Nuke

class CastCell: UICollectionViewCell {

    var imageView: UIImageView!
    var nameLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {

        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        contentView.layer.cornerRadius = 5
        contentView.layer.shadowOffset = CGSize(width: 0, height: 15)
        contentView.layer.shadowRadius = 15
        contentView.layer.shadowOpacity = 0.64

        imageView = UIImageView()
        imageView.backgroundColor = UIColor.black
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.init(1), for: .horizontal)
        imageView.setContentHuggingPriority(.init(1), for: .vertical)
        imageView.setContentCompressionResistancePriority(.init(1), for: .horizontal)
        imageView.setContentCompressionResistancePriority(.init(1), for: .vertical)
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)

        nameLabel = UILabel()
        nameLabel.textColor = UIColor.movieFinder.tertiery
        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 2
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -38),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
            ])
    }

    override func prepareForReuse() {
        imageView.image = nil
    }

    private func loadImage(imageURL: URL) {
        Nuke.loadImage(with: imageURL,
                       options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                       into: imageView)
    }

    func setData(actorName: String, imageURL: URL?) {

        nameLabel.text = actorName
        if let imageURL = imageURL {
            loadImage(imageURL: imageURL)
        }
    }
}


