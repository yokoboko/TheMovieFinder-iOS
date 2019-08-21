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
    //let genres: [Genre]?
    let genreIds: [Int]?
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let firstAirDate: String
    let voteAverage: Double?
    
    // Details
    let homepage: String?
    let videos: MovieVideosResponse?
    let images: ImagesResponse?
    let credits: CreditsResponse
    let similar: TVShowResponse?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName = "original_name"
        case overview
        //case genres
        case genreIds = "genre_ids"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        
        case homepage
        case videos
        case images
        case credits
        case similar
    }
}
