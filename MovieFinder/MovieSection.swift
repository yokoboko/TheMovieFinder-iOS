//
//  MovieSection.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 2.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

enum MovieSection {
    case movies, tvShows, favourites
}

extension MovieSection {
    var localizedName: String {
        switch self {
        case .movies: return "movies".localized
        case .tvShows: return "tvShows".localized
        case .favourites: return "favourites".localized
        }
    }
}
