//
//  MovieFilter.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 28.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

enum MovieFilter {

    case upcoming
    case trending
    case popular
    case topRated
    case genres([Genre])
    case search(String)
}

extension MovieFilter {

    static var all: [MovieFilter] {
        return [upcoming, trending,  popular, topRated, genres([]), search("")]
    }

    var localizedName: String {
        switch self {
        case .popular: return "popular".localized
        case .trending: return "trending".localized
        case .topRated: return "topRated".localized
        case .upcoming: return "upcoming".localized
        case .genres: return "genres".localized
        case .search: return "search".localized
        }
    }

    var index: Int {
        for (i, filter) in MovieFilter.all.enumerated() {
            if filter.localizedName == self.localizedName {
                return i
            }
        }
        return 0
    }
}
