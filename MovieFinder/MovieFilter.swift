//
//  MovieFilter.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 28.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

enum MovieFilter {

    case trending
    case upcoming
    case popular
    case topRated
    case genres([Genre])
    case search(String)
}

extension MovieFilter {

    static var all: [MovieFilter] {
        return [trending, upcoming, popular, topRated, genres([]), search("")]
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
}
