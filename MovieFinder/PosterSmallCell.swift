//
//  PosterSmallCell.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 27.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit
import Nuke

class PosterSmallCell: UICollectionViewCell {
    
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.black
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.init(1), for: .horizontal)
        imageView.setContentHuggingPriority(.init(1), for: .vertical)
        imageView.setContentCompressionResistancePriority(.init(1), for: .horizontal)
        imageView.setContentCompressionResistancePriority(.init(1), for: .vertical)
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var title: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.movieFinder.secondary
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.light)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var genres: UILabel = {
        let genres = UILabel(frame: .zero)
        genres.textColor = UIColor.movieFinder.tertiery
        genres.font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight.light)
        genres.translatesAutoresizingMaskIntoConstraints = false
        return genres
    }()
    
    var rating: UIPaddedLabel = {
        let label = UIPaddedLabel(frame: .zero)
        label.textColor = UIColor.movieFinder.primary
        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(netHex: 0xFFb10A)
        label.layer.cornerRadius = 9
        label.clipsToBounds = true
        label.leftInset = 8
        label.rightInset = 8
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        contentView.addSubview(title)
        contentView.addSubview(genres)
        
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        contentView.layer.cornerRadius = 5
        contentView.layer.shadowOffset = CGSize(width: 0, height: 15)
        contentView.layer.shadowRadius = 15
        contentView.layer.shadowOpacity = 0.64
        contentView.addSubview(imageView)
        
        contentView.addSubview(rating)
       
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            title.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            title.bottomAnchor.constraint(equalTo: genres.topAnchor, constant: 0),
            
            genres.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            genres.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            genres.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -38),
            
            rating.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            rating.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -7),
            rating.heightAnchor.constraint(equalToConstant: 18)
            ])
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func loadImage(imageURL: URL) {
        Nuke.loadImage(with: imageURL,
                       options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                       into: imageView)
    }
}

