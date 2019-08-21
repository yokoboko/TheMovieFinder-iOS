//
//  MovieAPIError.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

enum MovieAPIError: Error {
    case noResponse
    case jsonDecodingError(error: Error)
    case networkError(error: Error)
}
