//
//  AboutVC.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 20.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    let aboutView = AboutView()

    override func loadView() {
        view = aboutView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        aboutView.tmdbBtn.addTarget(self, action: #selector(webAction(_:)), for: .touchUpInside)
        aboutView.dismissBtn.addTarget(self, action: #selector(dismissAction(_:)), for: .touchUpInside)
    }

    @objc func webAction(_ sender: Any) {
        if let tmdbURL = URL(string: "https://wwww.themoviedb.org/") {
            UIApplication.shared.open(tmdbURL)
        }
    }

    @objc func dismissAction(_ sender: Any) {
        dismiss(animated: true)
    }
}
