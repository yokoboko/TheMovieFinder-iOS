//
//  PosterBigCell.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 22.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit
import Nuke

class PosterBigCell: UICollectionViewCell {
    
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
        
        contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
//    override var isHighlighted: Bool {
//        didSet {
//            shrink(down: isHighlighted)
//        }
//    }
//    
//    private func shrink(down: Bool) {
//        
//        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.allowUserInteraction, .curveEaseOut], animations: {
//            if down {
//                self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
//            } else {
//                self.transform = .identity
//            }
//        }, completion: nil)
//    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func loadImage(imageURL: URL) {
        Nuke.loadImage(with: imageURL,
                       options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)),
                       into: imageView)
    }
}
