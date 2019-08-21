//
//  MovieVideosResult.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

struct MovieVideosResponse: Codable {
    
    let results: [MovieVideo]
}
