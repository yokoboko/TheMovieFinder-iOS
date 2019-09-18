//
//  TVShow.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

struct TVShow: Codable {
    
    let id: Int
    let name: String
    let originalName: String

    let genreIds: [Int]?
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let firstAirDate: String?
    let voteAverage: Double?

    // Details
    let homepage: URL?
    let lastAirDate: String?
    let episodeRuntime: [Int]?
    let seasons: Int?
    let episodes: Int?
    let videos: MovieVideosResponse?
    let images: ImagesResponse?
    let credits: CreditsResponse?
    let similar: TVShowResponse?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName = "original_name"
        case overview
      
        case genreIds = "genre_ids"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        
        case homepage
        case lastAirDate = "last_air_date"
        case episodeRuntime = "episode_run_time"
        case seasons = "number_of_seasons"
        case episodes = "number_of_episodes"
        case videos
        case images
        case credits
        case similar
    }
}
