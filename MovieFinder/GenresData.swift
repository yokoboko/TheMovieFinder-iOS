//
//  GenresData.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 26.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

class GenresData {
    
    private static var movieGenres = [Genre]()
    private static var movieGenresNamesDict = [Int: String]()
    private static var tvShowGenres = [Genre]()
    private static var tvShowGenresNamesDict = [Int: String]()
    
    private static var loadingData = false
    
    static func loadGenres(completion: @escaping (Result<Bool, MovieAPIError>) -> Void) {
    
        guard loadingData == false else { return }
        
        loadingData = true
        loadMovieGenres(completion: completion)
    }
    
    private static func loadMovieGenres(completion: @escaping (Result<Bool, MovieAPIError>) -> Void) {
        
        MovieAPI.shared.GET(endpoint: .movieGenres) { (result: Result<GenresResult, MovieAPIError>) in
            
            switch result {
            case .success(let genresResult):
                movieGenres = genresResult.genres
                for genre in movieGenres { movieGenresNamesDict[genre.id] = genre.name }
                loadTVGenres(completion: completion)
                
            case .failure(let error):
                loadingData = false
                completion(.failure(error))
            }
        }
    }
    
    private static func loadTVGenres(completion: @escaping (Result<Bool, MovieAPIError>) -> Void) {
        
        MovieAPI.shared.GET(endpoint: .tvGenres) { (result: Result<GenresResult, MovieAPIError>) in
            
            switch result {
            case .success(let genresResult):
                tvShowGenres = genresResult.genres
                for genre in tvShowGenres { tvShowGenresNamesDict[genre.id] = genre.name }
                completion(.success(true))
                
            case .failure(let error):
                loadingData = false
                completion(.failure(error))
            }
        }
    }
    
    static func movieGenreNames(ids: [Int]?) -> [String] {
        
        var genreNames = [String]()
        if let ids = ids {
            for genreID in ids {
                if let genreName = movieGenresNamesDict[genreID] {
                    genreNames.append(genreName)
                }
            }
        }
        return genreNames
    }
    
    static func tvShowGenreNames(ids: [Int]?) -> [String] {
        
        var genreNames = [String]()
        if let ids = ids {
            for genreID in ids {
                if let genreName = tvShowGenresNamesDict[genreID] {
                    genreNames.append(genreName)
                }
            }
        }
        return genreNames
    }
}
