//
//  MovieNetworkDataSource.swift
//  Netflix Clone
//
//  Created by ndyyy on 13/03/24.
//

import Foundation

class MovieNetworkDataSource: MovieNetworkDataSourceProtocol {
    private let networkManager: MovieNetworkManager
    
    init(networkManager: MovieNetworkManager = MovieNetworkManager.shared) {
        self.networkManager = networkManager
    }
    
    private func fetch(from urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else { throw NetworkError.failedToCreateURL }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw NetworkError.failedToGetData
        }
    }
    
    private func decodeData(_ data: Data) throws -> [Movie] {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let results = try decoder.decode(MovieResponse.self, from: data)
            let movies = results.results.map { MovieDTOMapper.map($0) }
            return movies
        } catch {
            throw NetworkError.failedToGetData
        }
    }
    
    private func movies(from urlString: String) async throws -> [Movie] {
        let data = try await fetch(from: urlString)
        return try decodeData(data)
    }
    
    func getTrendingMovies() async throws -> [Movie] {
        let urlString = "\(networkManager.baseURL)/trending/movie/day?api_key=\(networkManager.API_KEY)"
        return try await movies(from: urlString)
    }
    
    func getTrendingTV() async throws -> [Movie] {
        let urlString = "\(networkManager.baseURL)/trending/tv/day?api_key=\(networkManager.API_KEY)"
        return try await movies(from: urlString)
    }
    
    func getPopular() async throws -> [Movie] {
        let urlString = "\(networkManager.baseURL)/movie/popular?api_key=\(networkManager.API_KEY)&language=en-US&page=1"
        return try await movies(from: urlString)
    }
    
    func getTopRated() async throws -> [Movie] {
        let urlString = "\(networkManager.baseURL)/movie/top_rated?api_key=\(networkManager.API_KEY)&language=en-US&page=1"
        return try await movies(from: urlString)
    }
    
    func getUpcomingMovie() async throws -> [Movie] {
        let urlString = "\(networkManager.baseURL)/movie/upcoming?api_key=\(networkManager.API_KEY)&language=en-US&page=1"
        return try await movies(from: urlString)
    }
    
    func getDiscoverMovies() async throws -> [Movie] {
        let urlString = "\(networkManager.baseURL)/discover/movie?api_key=\(networkManager.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        return try await movies(from: urlString)
    }
    
    func searchByKeyword(keyword: String) async throws -> [Movie] {
        guard let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { throw NetworkError.failedToAddPercentDecoding }
        let urlString = "\(networkManager.baseURL)/search/movie?api_key=\(networkManager.API_KEY)&query=\(query)"
        return try await movies(from: urlString)
    }
}
