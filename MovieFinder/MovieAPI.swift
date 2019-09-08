//
//  MovieAPI.swift
//  MovieFinder
//
//  Created by Yosif Iliev on 21.08.19.
//  Copyright © 2019 Yosif Iliev. All rights reserved.
//

import Foundation

struct MovieAPI {

    static let shared = MovieAPI()
    private init() {}
    
    private let baseURL = URL(string: "https://api.themoviedb.org/3")!
    private let apiKey = "85147bce93d9ec42d519a3fa3ef8f2b1"
    private var decoder = JSONDecoder()
    
    @discardableResult
    func GET<T: Codable>(endpoint: MovieAPIEndpoint,
                         params: [String: String]? = nil,
                         printDebug: Bool = false,
                         completionHandler: @escaping (Result<T, MovieAPIError>) -> Void) -> URLSessionDataTask {
        
        let queryURL = baseURL.appendingPathComponent(endpoint.path)
        var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: Locale.preferredLanguages[0])
        ]
        if let params = params {
            for (_, value) in params.enumerated() {
                components.queryItems?.append(URLQueryItem(name: value.key, value: value.value))
            }
        }
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.noResponse))
                }
                return
            }

            if printDebug { print(queryURL.absoluteString); print("------------------"); print(String(data: data, encoding: .utf8)!); }

            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.networkError(error: error!)))
                }
                return
            }
            
            do {
                let object = try self.decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(object))
                }
            } catch let error {
                DispatchQueue.main.async {
                    if printDebug { print("JSON Decoding Error: \(error)"); print(String(data: data, encoding: .utf8)!); }
                    completionHandler(.failure(.jsonDecodingError(error: error)))
                }
            }
            
            
        }
        task.resume()
        return task
    }
}
