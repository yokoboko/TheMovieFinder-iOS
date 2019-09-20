//
//  FavouriteFilter.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 19.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

enum FavouriteFilter {

    case all
    case movies
    case tvShows
}

extension FavouriteFilter {

    static var list: [FavouriteFilter] {
        return [all, movies,  tvShows]
    }

    var localizedName: String {
        switch self {
        case .all: return "allFavourites".localized
        case .movies: return "movies".localized
        case .tvShows: return "tvShows".localized
        }
    }

    var index: Int {
        for (i, filter) in FavouriteFilter.list.enumerated() {
            if filter.localizedName == self.localizedName {
                return i
            }
        }
        return 0
    }
}
