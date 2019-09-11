//
//  MovieImagePath.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

enum MovieImagePath: String {
    case small = "https://image.tmdb.org/t/p/w154/"
    case medium = "https://image.tmdb.org/t/p/w342/"
    case large = "https://image.tmdb.org/t/p/w500/"
    case castSmall = "https://image.tmdb.org/t/p/w185/"
    case castMedium = "https://image.tmdb.org/t/p/h632/"
    case original = "https://image.tmdb.org/t/p/original/"
    case backgropSmall = "https://image.tmdb.org/t/p/w300/"
    case backgropMedium = "https://image.tmdb.org/t/p/w780/"
    case backgropLarge = "https://image.tmdb.org/t/p/w1280/"
    func path(poster: String) -> URL {
        return URL(string: rawValue)!.appendingPathComponent(poster)
    }
}
