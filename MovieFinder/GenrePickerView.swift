//
//  GenrePickerView.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 5.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class GenrePickerView: UIView {

    var titleLabel: UILabel!
    var tableView: UITableView!
    var doneBtn: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}

extension GenrePickerView {

    private func setupViews() {

        setupBackgroundView()
        setupDoneButton()
        setupTitle()
        setupTableView()

    }

    private func setupBackgroundView() {

        backgroundColor = .clear

        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = frame
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurEffectView)

        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurEffectView.leftAnchor.constraint(equalTo: leftAnchor),
            blurEffectView.rightAnchor.constraint(equalTo: rightAnchor)
            ])
    }

    private func setupTitle() {

        titleLabel = UILabel()
        titleLabel.textColor = UIColor.movieFinder.secondary
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.regular)
        titleLabel.text = "selectGenres".localized
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeTopAnchor, constant: 32),
            titleLabel.leftAnchor.constraint(equalTo: safeLeftAnchor, constant: 40)
            ])
    }

    private func setupDoneButton() {

        doneBtn = UIButton()
        doneBtn.setTitle("done".localized, for: .normal)
        doneBtn.setTitleColor(UIColor.movieFinder.tertiery, for: .normal)
        doneBtn.layer.cornerRadius = 25
        doneBtn.layer.borderWidth = 1
        doneBtn.layer.borderColor = UIColor.movieFinder.tertiery.cgColor
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(doneBtn)

        NSLayoutConstraint.activate([
            doneBtn.leftAnchor.constraint(equalTo: safeLeftAnchor, constant: 40),
            doneBtn.rightAnchor.constraint(equalTo: safeRightAnchor, constant: -40),
            doneBtn.heightAnchor.constraint(equalToConstant: 50),
            doneBtn.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -32)
            ])
    }

    private func setupTableView() {

        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = 50
        addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            tableView.bottomAnchor.constraint(equalTo: doneBtn.topAnchor, constant: -32),
            tableView.leftAnchor.constraint(equalTo: safeLeftAnchor, constant: 40),
            tableView.rightAnchor.constraint(equalTo: safeRightAnchor, constant: -42)
            ])
    }
}
