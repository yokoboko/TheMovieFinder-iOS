//
//  ImagesResponse.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

struct ImagesResponse: Codable {
    
    let backdrops: [String]
    let posters: [String]
}
