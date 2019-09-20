//
//  Favourite+CoreDataClass.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 18.09.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//
//

import Foundation
import CoreData


public class Favourite: NSManagedObject {

    func getMovie() -> Movie {

        return Movie(id: Int(id),
                     title: title ?? "",
                     genreIDs: genreIDs,
                     overview: overview,
                     posterPath: posterPath,
                     releaseDate: date,
                     voteAverage: voteAverage,
                     homepage: nil,
                     videos: nil,
                     images: nil,
                     credits: nil,
                     similar: nil,
                     runtime: nil)
    }

    func getTVShow() -> TVShow {

        return TVShow(id: Int(id),
                      title: title ?? "",
                      genreIDs: genreIDs,
                      overview: overview,
                      posterPath: posterPath,
                      firstAirDate: date,
                      voteAverage: voteAverage,
                      homepage: nil,
                      lastAirDate: nil,
                      episodeRuntime: nil,
                      seasons: nil,
                      episodes: nil,
                      videos: nil,
                      images: nil,
                      credits: nil,
                      similar: nil)
    }
}
