//
//  MovieNetworkDataSource.swift
//  Netflix Clone
//
//  Created by ndyyy on 13/03/24.
//

import Foundation


enum APIError: Error {
    case failedToGetData
    var localizedDescription: String {
        switch self {
        case .failedToGetData:
            return "Failed to get data"
        }
    }
}

class MovieNetworkDataSource: MovieNetworkDataSourceProtocol {
    private let networkManager: MovieNetworkManager
    
    init(networkManager: MovieNetworkManager = MovieNetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    private func fetch(from urlString: String, completion: @escaping (Result<[Movie], Error>) -> Void) async {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let results = try decoder.decode(Response.self, from: data)
                    
                    completion(.success(results.results))
                } catch {
                    
                    completion(.failure(APIError.failedToGetData))
                }
            }
            .resume()
        }
    }
    
    func getTrendingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) async {
        let urlString = "\(networkManager.baseURL)/trending/movie/day?api_key=\(networkManager.API_KEY)"
        await fetch(from: urlString, completion: completion)
    }
    
    func getTrendingTV(completion: @escaping (Result<[Movie], Error>) -> Void) async {
        let urlString = "\(networkManager.baseURL)/trending/tv/day?api_key=\(networkManager.API_KEY)"
        await fetch(from: urlString, completion: completion)
    }
    
    func getPopular(completion: @escaping (Result<[Movie], Error>) -> Void) async {
        let urlString = "\(networkManager.baseURL)/movie/popular?api_key=\(networkManager.API_KEY)&language=en-US&page=1"
        await fetch(from: urlString, completion: completion)
    }
    
    func getTopRated(completion: @escaping (Result<[Movie], Error>) -> Void) async {
        let urlString = "\(networkManager.baseURL)/movie/top_rated?api_key=\(networkManager.API_KEY)&language=en-US&page=1"
        await fetch(from: urlString, completion: completion)
    }
    
    func getUpcomingMovie(completion: @escaping (Result<[Movie], Error>) -> Void) async {
        let urlString = "\(networkManager.baseURL)/movie/upcoming?api_key=\(networkManager.API_KEY)&language=en-US&page=1"
        await fetch(from: urlString, completion: completion)
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Movie], Error>) -> Void) async {
        let urlString = "\(networkManager.baseURL)/discover/movie?api_key=\(networkManager.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        await fetch(from: urlString, completion: completion)
    }
    
    func searchByKeyword(keyword: String, completion: @escaping (Result<[Movie], Error>) -> Void) async {
        guard let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let urlString = "\(networkManager.baseURL)/search/movie?api_key=\(networkManager.API_KEY)&query=\(query)"
        await fetch(from: urlString, completion: completion)
    }
}
