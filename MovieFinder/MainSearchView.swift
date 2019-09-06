//
//  SearchView.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 6.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class MainSearchView: UIView {

    var searchField: UITextField!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}

extension MainSearchView {

    private func setupViews() {

        backgroundColor = .clear
        layer.cornerRadius = 16
        layer.shadowOffset = CGSize(width: 0, height: -8)
        layer.shadowRadius = 16
        layer.shadowOpacity = 0.42
        layer.shadowColor = UIColor.black.cgColor

        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.clipsToBounds = true
        blurEffectView.layer.cornerRadius = 16
        addSubview(blurEffectView)

        searchField = UITextField()
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.autocorrectionType = .no
        searchField.textColor = UIColor.movieFinder.primary
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.movieFinder.tertiery]
        searchField.attributedPlaceholder = NSAttributedString(string: "search".localized, attributes: attributes)
        searchField.leftViewMode = .always
        let searchImageView = UIImageView(image: UIImage(named: "icon_search"))
        searchImageView.contentMode = .left
        if let size = searchImageView.image?.size {
            searchImageView.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 8.0, height: size.height)
        }
        searchField.leftView = searchImageView
        addSubview(searchField)

        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurEffectView.leftAnchor.constraint(equalTo: leftAnchor),
            blurEffectView.rightAnchor.constraint(equalTo: rightAnchor),

            searchField.leftAnchor.constraint(equalTo: safeLeftAnchor, constant: 16),
            searchField.rightAnchor.constraint(equalTo: safeRightAnchor, constant: -16),
            searchField.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -8)
            ])
    }
}
