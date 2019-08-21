//
//  Cast.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

struct Cast: Codable {
    
    let id: Int
    let character: String
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, character, name
        case profilePath = "profile_path"
    }
}
