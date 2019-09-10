//
//  MovieVideo.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

struct MovieVideo: Codable {
    
    let id: String
    let key: String
    let site: String?
    let name: String?
    let type: String?

    var thumbURL: URL? {
        get {
            if site == "YouTube", let url = URL(string: "https://img.youtube.com/vi/\(key)/hqdefault.jpg") {
                return url
            }
            return nil
        }
    }
}
