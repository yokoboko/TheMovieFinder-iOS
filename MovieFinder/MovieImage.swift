//
//  MovieImage.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 10.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

struct MovieImage: Codable {

    let filePath: String?
    let width: Int?
    let height: Int?
    let aspect: Double?

    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
        case width
        case height
        case aspect = "aspect_ratio"
    }
}
