//
//  CreditsResponse.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

struct CreditsResponse: Codable {
    
    let cast: [Cast]
    let crew: [Crew]
}
