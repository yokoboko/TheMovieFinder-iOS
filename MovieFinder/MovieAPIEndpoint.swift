//
//  MovieAPIEndpoint.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

enum MovieAPIEndpoint {
    
    case moviePopular
    case movieTopRated
    case movieUpcoming
    case movieTrending
    case movieDiscover
    case movieSearch
    case movieDetail(id: Int)
    case movieGenres
    
    case tvPopular
    case tvTopRated
    case tvOnTheAir
    case tvTrending
    case tvDiscover
    case tvSearch
    case tvDetail(id: Int)
    case tvGenres
    
    var path: String {
        switch self {
        case .moviePopular: return "movie/popular"
        case .movieTopRated: return "movie/top_rated"
        case .movieUpcoming: return "movie/upcoming"
        case .movieTrending: return "trending/movie/week"
        case .movieDiscover: return "discover/movie"
        case .movieSearch: return "search/movie"
        case let .movieDetail(movie): return "movie/\(String(movie))"
        case .movieGenres: return "genre/movie/list"
            
        case .tvPopular: return "tv/popular"
        case .tvTopRated: return "tv/top_rated"
        case .tvOnTheAir: return "tv/on_the_air"
        case .tvTrending: return "trending/tv/week"
        case .tvDiscover: return "discover/tv"
        case .tvSearch: return "search/tv"
        case let .tvDetail(tv): return "tv/\(String(tv))"
        case .tvGenres: return "genre/tv/list"
        }
    }
}
