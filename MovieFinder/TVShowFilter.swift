//
//  TVShowFilter.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 16.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

enum TVShowFilter {

    case onTheAir
    case trending
    case popular
    case topRated
    case genres([Genre])
    case search(String)
}

extension TVShowFilter {

    static var list: [TVShowFilter] {
        return [onTheAir, trending,  popular, topRated, genres([]), search("")]
    }

    var localizedName: String {
        switch self {
        case .popular: return "popular".localized
        case .trending: return "trending".localized
        case .topRated: return "topRated".localized
        case .onTheAir: return "onTheAir".localized
        case .genres: return "genres".localized
        case .search: return "search".localized
        }
    }

    var index: Int {
        for (i, filter) in TVShowFilter.list.enumerated() {
            if filter.localizedName == self.localizedName {
                return i
            }
        }
        return 0
    }
}
