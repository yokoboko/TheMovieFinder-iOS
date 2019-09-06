//
//  DataSourceDelegate.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 22.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

protocol DataSourceDelegate: class {
    func itemOnFocus(name: String, voteAverage: Double?, genres: [String], year: String?, imageURL: URL?)
    func dataIsLoading()
    func dataLoaded()
}
