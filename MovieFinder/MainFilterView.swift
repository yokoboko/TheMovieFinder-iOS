//
//  MainFilterView.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 29.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class MainFilterView: UIStackView {

    var moviesBtn: UIButton!
    var tvShowsBtn: UIButton!
    var favouritesBtn: UIButton!

    var hideFilterBtn: UIButton!

    var filterSV: UIStackView!
    var filterBtns = [UIButton]()
    var filterFocusView: UIView!
    private var filterFocusXConstaint: NSLayoutConstraint!
    private var filterFocusBottomConstraint: NSLayoutConstraint!
    private var filterFocusWidthConstaint: NSLayoutConstraint!

    var searchField: UITextField!

    private var secondFilterRow: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    func setFilters(names: [String], selectIndex: Int) {
        for (index, name) in names.enumerated() {
            if index < filterBtns.count {
                let filterBtn = filterBtns[index]
                filterBtn.setTitle(name, for: .normal)
            }
        }
        secondFilterRow.isHidden = names.count <= 3
        selectFilter(selectIndex: selectIndex)
    }

    func selectFilter(selectIndex: Int) {
        if selectIndex < filterBtns.count {
            for (index, filterBtn) in filterBtns.enumerated() {
                filterBtn.setTitleColor(index == selectIndex ? UIColor.movieFinder.primary : UIColor.movieFinder.tertiery, for: .normal)
            }
            let filterBtn = filterBtns[selectIndex]
            filterFocusXConstaint.isActive = false
            filterFocusBottomConstraint.isActive = false
            filterFocusWidthConstaint.isActive = false
            filterFocusXConstaint = filterFocusView.centerXAnchor.constraint(equalTo: filterBtn.centerXAnchor)
            filterFocusBottomConstraint = filterFocusView.bottomAnchor.constraint(equalTo: filterBtn.centerYAnchor, constant: 12)
            filterFocusWidthConstaint = filterFocusView.widthAnchor.constraint(equalTo: filterBtn.widthAnchor)
            NSLayoutConstraint.activate([
                filterFocusXConstaint,
                filterFocusBottomConstraint,
                filterFocusWidthConstaint
                ])
        }
    }

    func selectSection(section: MovieSection) {

        switch section {
        case .movies:
            moviesBtn.setTitleColor(UIColor.movieFinder.primary, for: .normal)
            moviesBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            moviesBtn.backgroundColor = UIColor.movieFinder.tertiery
            tvShowsBtn.setTitleColor(UIColor.movieFinder.tertiery, for: .normal)
            tvShowsBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
            tvShowsBtn.backgroundColor = .clear
            favouritesBtn.setTitleColor(UIColor.movieFinder.tertiery, for: .normal)
            favouritesBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
            favouritesBtn.backgroundColor = .clear

        case .tvShows:
            moviesBtn.setTitleColor(UIColor.movieFinder.tertiery, for: .normal)
            moviesBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
            moviesBtn.backgroundColor = .clear
            tvShowsBtn.setTitleColor(UIColor.movieFinder.primary, for: .normal)
            tvShowsBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            tvShowsBtn.backgroundColor = UIColor.movieFinder.tertiery
            favouritesBtn.setTitleColor(UIColor.movieFinder.tertiery, for: .normal)
            favouritesBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
            favouritesBtn.backgroundColor = .clear

        case .favourites:
            moviesBtn.setTitleColor(UIColor.movieFinder.tertiery, for: .normal)
            moviesBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
            moviesBtn.backgroundColor = .clear
            tvShowsBtn.setTitleColor(UIColor.movieFinder.tertiery, for: .normal)
            tvShowsBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
            tvShowsBtn.backgroundColor = .clear
            favouritesBtn.setTitleColor(UIColor.movieFinder.primary, for: .normal)
            favouritesBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            favouritesBtn.backgroundColor = UIColor.movieFinder.tertiery
        }
    }
}

extension MainFilterView {

    private func setupViews() {

        axis = .vertical
        distribution = .equalSpacing
        spacing = 0

        setupSectionView()
        setupFilterView()
        setupHideBtn()
    }

    private func setupSectionView() {

        let background = UIView(frame: .zero)
        background.translatesAutoresizingMaskIntoConstraints = false
        background.layer.borderColor = UIColor.movieFinder.tertiery.cgColor
        background.layer.borderWidth = 1
        background.layer.cornerRadius = 20
        addArrangedSubview(background)

        moviesBtn = createSectionBtn(title: "movies".localized)
        moviesBtn.tag = 0
        moviesBtn.backgroundColor = UIColor.movieFinder.tertiery
        moviesBtn.setTitleColor(UIColor.movieFinder.primary, for: .normal)
        moviesBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        background.addSubview(moviesBtn)

        tvShowsBtn = createSectionBtn(title: "tvShows".localized)
        tvShowsBtn.tag = 1
        background.addSubview(tvShowsBtn)

        favouritesBtn = createSectionBtn(title: "favourites".localized)
        favouritesBtn.tag = 2
        background.addSubview(favouritesBtn)

        NSLayoutConstraint.activate([
            background.heightAnchor.constraint(equalToConstant: 40),

            moviesBtn.widthAnchor.constraint(equalTo: background.widthAnchor, multiplier: 1 / 3),
            moviesBtn.leftAnchor.constraint(equalTo: background.leftAnchor, constant: 1),
            moviesBtn.safeTopAnchor.constraint(equalTo: background.topAnchor, constant: 1),
            moviesBtn.heightAnchor.constraint(equalToConstant: 38),

            tvShowsBtn.widthAnchor.constraint(equalTo: background.widthAnchor, multiplier: 1 / 3),
            tvShowsBtn.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            tvShowsBtn.safeTopAnchor.constraint(equalTo: background.topAnchor, constant: 1),
            tvShowsBtn.heightAnchor.constraint(equalToConstant: 38),

            favouritesBtn.widthAnchor.constraint(equalTo: background.widthAnchor, multiplier: 1 / 3),
            favouritesBtn.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -1),
            favouritesBtn.safeTopAnchor.constraint(equalTo: background.topAnchor, constant: 1),
            favouritesBtn.heightAnchor.constraint(equalToConstant: 38)
            ])
    }

    private func createSectionBtn(title: String) -> UIButton {

        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 19
        btn.setTitleColor(UIColor.movieFinder.tertiery, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        btn.backgroundColor = .clear
        btn.setTitle(title, for: .normal)
        return btn
    }

    private func setupFilterView() {

        filterSV = UIStackView()
        filterSV.axis = .vertical
        filterSV.distribution = .equalSpacing
        filterSV.spacing = 8
        filterSV.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 0, right: 12)
        filterSV.isLayoutMarginsRelativeArrangement = true
        filterSV.translatesAutoresizingMaskIntoConstraints = false
        addArrangedSubview(filterSV)

        filterSV.addArrangedSubview(createFilterRow())
        secondFilterRow = createFilterRow()
        filterSV.addArrangedSubview(secondFilterRow)

        filterFocusView = UIView()
        filterFocusView.backgroundColor = UIColor.movieFinder.primary
        filterFocusView.translatesAutoresizingMaskIntoConstraints = false
        filterSV.addSubview(filterFocusView)

        let firstFilterBtn = filterBtns[0]
        filterFocusXConstaint = filterFocusView.centerXAnchor.constraint(equalTo: firstFilterBtn.centerXAnchor)
        filterFocusBottomConstraint = filterFocusView.bottomAnchor.constraint(equalTo: firstFilterBtn.bottomAnchor)
        filterFocusWidthConstaint = filterFocusView.widthAnchor.constraint(equalTo: firstFilterBtn.widthAnchor)

        NSLayoutConstraint.activate([
            filterSV.heightAnchor.constraint(equalToConstant: 82),
            filterFocusView.heightAnchor.constraint(equalToConstant: 2),
            filterFocusXConstaint,
            filterFocusBottomConstraint,
            filterFocusWidthConstaint
            ])
    }

    private func createFilterRow() -> UIView {

        let row = UIView()
        row.translatesAutoresizingMaskIntoConstraints = false
        //row.heightAnchor.constraint(equalToConstant: 36)

        let leftBtn = createFilterBtn()
        let midBtn = createFilterBtn()
        let rightBtn = createFilterBtn()
        row.addSubview(leftBtn)
        row.addSubview(midBtn)
        row.addSubview(rightBtn)

        NSLayoutConstraint.activate([
            leftBtn.leftAnchor.constraint(equalTo: row.leftAnchor),
            leftBtn.topAnchor.constraint(equalTo: row.topAnchor),
            leftBtn.bottomAnchor.constraint(equalTo: row.bottomAnchor),

            midBtn.centerXAnchor.constraint(equalTo: row.centerXAnchor),
            midBtn.topAnchor.constraint(equalTo: row.topAnchor),
            midBtn.bottomAnchor.constraint(equalTo: row.bottomAnchor),

            rightBtn.rightAnchor.constraint(equalTo: row.rightAnchor),
            rightBtn.topAnchor.constraint(equalTo: row.topAnchor),
            rightBtn.bottomAnchor.constraint(equalTo: row.bottomAnchor),
            ])

        return row
    }

    private func createFilterBtn() -> UIButton {

        let btn = UIButton()
        btn.setTitleColor(UIColor.movieFinder.tertiery, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tag = filterBtns.count
        filterBtns.append(btn)
        return btn
    }

    private func setupHideBtn() {

        let containerSV = UIStackView()
        containerSV.translatesAutoresizingMaskIntoConstraints = false
        containerSV.layoutMargins = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        containerSV.isLayoutMarginsRelativeArrangement = true
        addArrangedSubview(containerSV)

        hideFilterBtn = UIButton()
        hideFilterBtn.setImage(UIImage(named: "btn_filters"), for: .normal)
        hideFilterBtn.contentVerticalAlignment = .top
        hideFilterBtn.translatesAutoresizingMaskIntoConstraints = false
        hideFilterBtn.heightAnchor.constraint(equalToConstant: 34)
        containerSV.addArrangedSubview(hideFilterBtn)
    }
}
