//
//  AboutView.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 20.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class AboutView: UIView {

    var tmdbBtn: UIButton!
    var dismissBtn: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}

extension AboutView {

    func setupViews() {

        backgroundColor = .clear

        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.frame = frame
        addSubview(blurEffectView)

        let holder = UIView()
        holder.translatesAutoresizingMaskIntoConstraints = false
        addSubview(holder)

        let appLogo = UIImageView(image: UIImage(named: "icon_app"))
        appLogo.translatesAutoresizingMaskIntoConstraints = false
        holder.addSubview(appLogo)

        let appNameLabel = UILabel()
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.textColor = UIColor.movieFinder.secondary
        appNameLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        appNameLabel.text = "appName".localized
        holder.addSubview(appNameLabel)

        let appInfoLabel = UILabel()
        appInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        appInfoLabel.numberOfLines = 0
        appInfoLabel.textColor = UIColor.movieFinder.tertiery
        appInfoLabel.textAlignment = .center
        appInfoLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        appInfoLabel.text = "appInfo".localized
        holder.addSubview(appInfoLabel)

        let tmdbInfoLabel = UILabel()
        tmdbInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        tmdbInfoLabel.numberOfLines = 0
        tmdbInfoLabel.textColor = UIColor.movieFinder.tertiery
        tmdbInfoLabel.textAlignment = .center
        tmdbInfoLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        tmdbInfoLabel.text = "tmdbInfo".localized
        holder.addSubview(tmdbInfoLabel)

        tmdbBtn = UIButton()
        tmdbBtn.translatesAutoresizingMaskIntoConstraints = false
        tmdbBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        tmdbBtn.setTitle("www.themoviedb.org", for: .normal)
        tmdbBtn.setTitleColor(UIColor(netHex: 0x01D277), for: .normal)
        holder.addSubview(tmdbBtn)

        let tmdbLogo = UIImageView(image: UIImage(named: "icon_tmdb"))
        tmdbLogo.translatesAutoresizingMaskIntoConstraints = false
        holder.addSubview(tmdbLogo)

        dismissBtn = UIButton(type: .custom)
        dismissBtn.translatesAutoresizingMaskIntoConstraints = false
        dismissBtn.setImage(UIImage(named: "btn_close"), for: .normal)
        addSubview(dismissBtn)

        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurEffectView.leftAnchor.constraint(equalTo: leftAnchor),
            blurEffectView.rightAnchor.constraint(equalTo: rightAnchor),

            holder.leftAnchor.constraint(equalTo: safeLeftAnchor, constant: 40),
            holder.rightAnchor.constraint(equalTo: safeRightAnchor, constant: -40),
            holder.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -24),

            appLogo.centerXAnchor.constraint(equalTo: holder.centerXAnchor),
            appLogo.topAnchor.constraint(equalTo: holder.topAnchor),
            appLogo.widthAnchor.constraint(equalToConstant: 128),
            appLogo.heightAnchor.constraint(equalToConstant: 128),

            appNameLabel.centerXAnchor.constraint(equalTo: holder.centerXAnchor),
            appNameLabel.topAnchor.constraint(equalTo: appLogo.bottomAnchor, constant: 8),

            appInfoLabel.centerXAnchor.constraint(equalTo: holder.centerXAnchor),
            appInfoLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 24),
            appInfoLabel.leftAnchor.constraint(equalTo: holder.leftAnchor),
            appInfoLabel.rightAnchor.constraint(equalTo: holder.rightAnchor),

            tmdbInfoLabel.centerXAnchor.constraint(equalTo: holder.centerXAnchor),
            tmdbInfoLabel.topAnchor.constraint(equalTo: appInfoLabel.bottomAnchor, constant: 32),
            tmdbInfoLabel.leftAnchor.constraint(equalTo: holder.leftAnchor),
            tmdbInfoLabel.rightAnchor.constraint(equalTo: holder.rightAnchor),

            tmdbBtn.centerXAnchor.constraint(equalTo: holder.centerXAnchor),
            tmdbBtn.topAnchor.constraint(equalTo: tmdbInfoLabel.bottomAnchor, constant: 8),

            tmdbLogo.centerXAnchor.constraint(equalTo: holder.centerXAnchor),
            tmdbLogo.topAnchor.constraint(equalTo: tmdbBtn.bottomAnchor, constant: 8),
            tmdbLogo.bottomAnchor.constraint(equalTo: holder.bottomAnchor),
            tmdbLogo.widthAnchor.constraint(equalToConstant: 128),
            tmdbLogo.heightAnchor.constraint(equalToConstant: 128),

            dismissBtn.widthAnchor.constraint(equalToConstant: 44),
            dismissBtn.heightAnchor.constraint(equalToConstant: 44),
            dismissBtn.centerXAnchor.constraint(equalTo: centerXAnchor),
            dismissBtn.bottomAnchor.constraint(equalTo: safeBottomAnchor, constant: -6)
            ])
    }
}
