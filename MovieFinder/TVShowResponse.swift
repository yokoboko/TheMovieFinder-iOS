//
//  TVShowResponse.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

struct TVShowResponse: Codable {
    
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [TVShow]
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
