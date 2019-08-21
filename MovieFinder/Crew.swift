//
//  Crew.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

struct Crew: Codable {
    
    let id: Int
    let job: String
    let department: String
    let name: String
    let profilePath: String?
    enum CodingKeys: String, CodingKey {
        case id, job, department, name
        case profilePath = "profile_path"
    }
}
