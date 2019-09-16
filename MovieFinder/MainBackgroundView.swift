//
//  MainBackgroundView.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit
import Nuke

class BackgroundMoviesView: UIView {
    
    private var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor =  UIColor(netHex: 0x555555) // .black
        
        imageView = UIImageView(frame: frame)
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.init(1), for: .horizontal)
        imageView.setContentHuggingPriority(.init(1), for: .vertical)
        imageView.setContentCompressionResistancePriority(.init(1), for: .horizontal)
        imageView.setContentCompressionResistancePriority(.init(1), for: .vertical)
        imageView.alpha = 0.38
        addSubview(imageView)

        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurEffectView)

        let topGradient = GradientView(frame: frame)
        topGradient.startColor = UIColor.black.withAlphaComponent(0.8)
        topGradient.endColor = UIColor.black.withAlphaComponent(0.0)
        topGradient.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topGradient)

        let bottomGradient = GradientView(frame: frame)
        bottomGradient.startColor = UIColor.black.withAlphaComponent(0.0)
        bottomGradient.endColor = UIColor.black.withAlphaComponent(0.8)
        bottomGradient.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomGradient)


        NSLayoutConstraint.activate([

            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 2),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2),

            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.leftAnchor.constraint(equalTo: leftAnchor),
            blurEffectView.rightAnchor.constraint(equalTo: rightAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),

            topGradient.topAnchor.constraint(equalTo: topAnchor),
            topGradient.leftAnchor.constraint(equalTo: leftAnchor),
            topGradient.rightAnchor.constraint(equalTo: rightAnchor),
            topGradient.heightAnchor.constraint(equalToConstant: 200),

            bottomGradient.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomGradient.leftAnchor.constraint(equalTo: leftAnchor),
            bottomGradient.rightAnchor.constraint(equalTo: rightAnchor),
            bottomGradient.heightAnchor.constraint(equalToConstant: 200)
            ])
    }
    
    func setImage(image: UIImage) {
        DispatchQueue.global(qos: .userInteractive).async {
            let saturated = image.withSaturationAdjustment(byVal: 4)
            DispatchQueue.main.async {
                UIView.transition(with: self.imageView,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.imageView.image = saturated
                }, completion: nil)
            }
        }
    }
    
    private weak var imageTask: ImageTask?
    
    func loadImage(url: URL) {
        
        imageTask?.cancel()
        imageTask = ImagePipeline.shared.loadImage(with: url, progress: nil) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let imageResponse): self.setImage(image: imageResponse.image)
            default: break
            }
        }
    }
}




