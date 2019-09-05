//
//  GenreCell.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 5.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class GenreCell: UITableViewCell {

    private var dot: UIView!
    private var nameLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(name: String, selected: Bool) {

        let color = selected ? UIColor.movieFinder.secondary : UIColor.movieFinder.tertiery

        nameLabel.text = name
        nameLabel.textColor = color
        dot.layer.borderColor = color.cgColor
        dot.backgroundColor = selected ? color : .clear
    }
}

extension GenreCell {

    private func setupViews() {

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        setupSeparatorView()
        setupDotView()
        setupNameLabelView()
    }

    private func setupSeparatorView() {

        let separator = UIView()
        separator.backgroundColor = UIColor.movieFinder.tertiery
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)

        NSLayoutConstraint.activate([
            separator.heightAnchor.constraint(equalToConstant: 1),
            separator.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            separator.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
    }

    private func setupDotView() {

        dot = UIView()
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.backgroundColor = .clear
        dot.layer.cornerRadius = 4
        dot.layer.borderWidth = 1
        dot.layer.borderColor = UIColor.movieFinder.tertiery.cgColor
        contentView.addSubview(dot)

        NSLayoutConstraint.activate([
            dot.widthAnchor.constraint(equalToConstant: 8),
            dot.heightAnchor.constraint(equalToConstant: 8),
            dot.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            dot.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }

    private func setupNameLabelView() {

        nameLabel = UILabel()
        nameLabel.textColor = UIColor.movieFinder.tertiery
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: dot.rightAnchor, constant: 8)
            ])
    }
}
