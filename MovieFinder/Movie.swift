//
//  Movie.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    let id: Int
    let title: String
    let genreIds: [Int]?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    
    // Details
    let homepage: URL?
    let videos: MovieVideosResponse?
    let images: ImagesResponse?
    let credits: CreditsResponse?
    let similar: MovieResponse?
    let runtime: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case genreIds = "genre_ids"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        
        case homepage
        case videos
        case images
        case credits
        case similar
        case runtime
    }
}
