//
//  PosterBigCell.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 22.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit
import Nuke

class PosterBigCell: UICollectionViewCell, PosterCell {

    var imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        let shadowImage = UIImage(named: "shadow")?.resizableImage(withCapInsets: UIEdgeInsets(top: 20, left: 33, bottom: 39, right: 33), resizingMode: .stretch)
        let imageShadowView = UIImageView(image: shadowImage)
        imageShadowView.contentMode = .scaleToFill
        imageShadowView.translatesAutoresizingMaskIntoConstraints = false
        imageShadowView.isUserInteractionEnabled = false
        imageShadowView.setContentHuggingPriority(.init(1), for: .horizontal)
        imageShadowView.setContentHuggingPriority(.init(1), for: .vertical)
        imageShadowView.setContentCompressionResistancePriority(.init(1), for: .horizontal)
        imageShadowView.setContentCompressionResistancePriority(.init(1), for: .vertical)
        contentView.addSubview(imageShadowView)

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
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            imageShadowView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: -14),
            imageShadowView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 38),
            imageShadowView.leftAnchor.constraint(equalTo: imageView.leftAnchor, constant: -27),
            imageShadowView.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: 27),
            ])
    }

    override func prepareForReuse() {
        isHidden = false
        imageView.image = nil
    }
    
    func loadImage(imageURL: URL) {
        Nuke.loadImage(with: imageURL,
                       options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                       into: imageView)
    }
}
