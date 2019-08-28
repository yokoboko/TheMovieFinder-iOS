//
//  MovieFilter.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 28.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

enum MovieFilter {

    case popular
    case trending
    case topRated
    case upcoming
    case genres([Genre])
    case search(String)
}
