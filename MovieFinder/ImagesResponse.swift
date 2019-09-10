//
//  ImagesResponse.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

struct ImagesResponse: Codable {

    let id: Int?
    let backdrops: [MovieImage]
    let posters: [MovieImage]
}
